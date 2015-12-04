module Tufts
  module EADMethods


    def self.collection_url(fedora_obj)
      return "/catalog/" + fedora_obj.id
    end


    def self.finding_aid_url(fedora_obj)
      return "/catalog/ead/" + fedora_obj.id
    end

    def self.eadid(fedora_obj, datastream = "Archival.xml")
      result = ""
      url = ""
      eadid = fedora_obj.datastreams[datastream].find_by_terms_and_value(:eadheader).first
      eadid.element_children.each do |child|
        if child.name == "eadid"
          result << child.text
          url = child.attribute('url')
          url = url.text unless url.nil?
        end
      end



      return result, url
    end

    def self.title(fedora_obj, datastream = "Archival.xml", includeDate = true)
      result = ""
      unittitle = fedora_obj.datastreams[datastream].get_values(:unittitle).first
      unitdate = fedora_obj.datastreams[datastream].get_values(:unitdate).first

      unless unittitle.nil?
        if (includeDate)
          result << unittitle + (unitdate.nil? ? "" : ", " + unitdate)
        else
          result = unittitle
        end
      end

      return result
    end


    def self.physdesc(fedora_obj, datastream = "Archival.xml")
      result = ""
      physdescs = fedora_obj.datastreams[datastream].get_values(:physdesc).first

      if !physdescs.nil?
        result << physdescs.lstrip.rstrip
      end

      return result
    end


    def self.physdesc_split(fedora_obj, datastream = "Archival.xml")
      result = ""
      physdescs = fedora_obj.datastreams[datastream].get_values(:physdesc).first

      if !physdescs.nil?
        physdescs.split(";").each do |physdesc|
          result << (result.empty? ? "" : "<br>") + physdesc.lstrip.rstrip
        end
      end

      return result
    end


    def self.abstract(fedora_obj, datastream = "Archival.xml")
      result = ""
      abstract = fedora_obj.datastreams[datastream].get_values(:abstract).first

      if !abstract.nil?
        result << abstract
      end

      return result
    end

    def self.unitdate(fedora_obj, datastream = "Archival.xml")
      result = ""
      fedora_obj.datastreams[datastream].find_by_terms_and_value(:archdesc).children.each do |element|
        next unless element.name == "did"
        element.children.each do |child|
          childname = child.name
          if childname == "unitdate"
            return child.text
          end
        end
      end

      return result
    end

    def self.unitid_and_author(fedora_obj, datastream = "Archival.xml")
      unitid = nil
      author = ""
      fedora_obj.datastreams[datastream].find_by_terms_and_value(:archdesc).children.each do |element|
        next unless element.name == "did" || element.name == "origination"
        element.children.each do |child|
          childname = child.name
          if childname == "unitid"
            unitid = child.text
          elsif childname == "origination"
            child.children.each do |pers|
              if pers.name = "persname"
                author += pers.text.strip
              end
            end
          end

        end
      end

      return unitid, author
    end


    def self.read_more_about(fedora_obj, datastream = "Archival.xml")
      result = nil
      persname = fedora_obj.datastreams[datastream].find_by_terms_and_value(:persname)
      corpname = fedora_obj.datastreams[datastream].find_by_terms_and_value(:corpname)
      famname = fedora_obj.datastreams[datastream].find_by_terms_and_value(:famname)
      name = nil
      rcr_url = nil

      if !persname.empty?
        name, rcr_url = parse_origination(persname)
      elsif !corpname.empty?
        name, rcr_url = parse_origination(corpname)
      elsif !famname.empty?
        name, rcr_url = parse_origination(famname)
      end

      if !name.nil? && !rcr_url.nil?
        rcr_url = "tufts:" + rcr_url
        ingested = Tufts::PidMethods.ingested?(rcr_url)
        result = (ingested ? "<a href=\"/catalog/" + rcr_url + "\">" : "") + name + (ingested ? "</a>" : "")
      end

      return result
    end


    def self.get_contributors(fedora_obj, datastream = "Archival.xml")
      result = []
      controlaccesses = fedora_obj.datastreams[datastream].find_by_terms_and_value(:controlaccess)

      controlaccesses.each do |controlaccess|
        controlaccess.element_children.each do |element_child|
          childname = element_child.name

          if childname == "persname" || childname == "corpname" || childname == "subject" || childname == "geogname"
            child_name = element_child.text
            child_id = element_child.attribute("id")
            child_url = (child_id.nil? ? nil : child_id.text)

            if child_name.size > 0 && !child_url.nil?
              child_url = "tufts:" + child_url
              ingested = Tufts::PidMethods.ingested?(child_url)
              result << (ingested ? "<a href=\"/catalog/" + child_url + "\">" : "") + child_name + (ingested ? "</a>" : "")
            end
          end
        end
      end

      return result
    end


    def self.get_contents(fedora_obj, datastream = "Archival.xml")
      result = []
      scopecontentps = fedora_obj.datastreams[datastream].find_by_terms_and_value(:scopecontentp)

      scopecontentps.each do |scopecontentp|
        result << scopecontentp.text
      end

      return result
    end


    def self.get_serieses(fedora_obj, datastream = "Archival.xml")  # I got a D in speling once
      return fedora_obj.datastreams[datastream].find_by_terms_and_value(:series)
    end


    def self.get_series_elements(series)
      series_id = series.attribute("id").text
      did = nil
      scopecontent = nil
      c02s = []

      # find the pertinent child elements: did, scopecontent and c02
      series.element_children.each do |element_child|
        if element_child.name == "did"
          did = element_child
        elsif element_child.name == "scopecontent"
          scopecontent = element_child
        elsif element_child.name == "c02"
          level = element_child.attribute("level")
          if !level.nil? && level.text == "subseries"
            c02s << element_child
          end
        end
      end

      return series_id, did, scopecontent, c02s
    end


    def self.get_series_title(did, ead_id, series_id, series_level, no_subseries)
      result = ""

      # process the did element
      if !did.nil?
        unittitle = nil
        unitdate = nil

        did.element_children.each do |did_child|
          if did_child.name == "unittitle"
            unittitle = did_child.text
          elsif did_child.name == "unitdate"
            unitdate = did_child.text
          end
        end

        # This should be a link if there are no subseries elements (ie, <c02 level="subseries"> tags).
        if !unittitle.nil? && unittitle.size > 0
          result << (series_level.nil? ? "" : series_level + ". ") + (no_subseries ? "<a href=\"/catalog/ead/" + ead_id + "/" + series_id + "\">" : "") + unittitle + (unitdate.nil? ? "" : ", " + unitdate) + (no_subseries ? "</a>" : "")
        end
      end

      return result
    end


    def self.get_scopecontent_paragraphs(scopecontent)
      result = []

      # process the scopecontent element
      if !scopecontent.nil?
        scopecontent.element_children.each do |scopecontent_child|
          if scopecontent_child.name == "p"
            result << scopecontent_child.text
          elsif scopecontent_child.name == "note"
            scopecontent_child.element_children.each do |note_child|
              if note_child.name == "p"
                result << note_child.text
              end
            end
          end
        end
      end

      return result
    end


    def self.get_names_and_subjects(fedora_obj, datastream = "Archival.xml")
      result = []
      controlaccesses = fedora_obj.datastreams[datastream].find_by_terms_and_value(:controlaccess)

      controlaccesses.each do |controlaccess|
        controlaccess.element_children.each do |element_child|
          childname = element_child.name

          if childname == "persname" || childname == "corpname" || childname == "subject" || childname == "geogname"
            child_name = element_child.text
            child_id = element_child.attribute("id")
            child_url = (child_id.nil? ? nil : child_id.text)

            if child_name.size > 0
              ingested = !child_url.nil? && Tufts::PidMethods.ingested?(child_url)
              result << (ingested ? "<a href=\"/catalog/" + child_url + "\">" : "") + child_name + (ingested ? "</a>" : "")
            end
          end
        end
      end

      return result
    end


    def self.get_related_material(fedora_obj, datastream = "Archival.xml")
      result = []
      separatedmaterials = fedora_obj.datastreams[datastream].find_by_terms_and_value(:separatedmaterial)
      relatedmaterials = fedora_obj.datastreams[datastream].find_by_terms_and_value(:relatedmaterial)

      separatedmaterials.each do |separatedmaterial|
        result << separatedmaterial.text
      end

      relatedmaterials.each do |relatedmaterial|
        result << relatedmaterial.text
      end

      return result
    end


    def self.get_access_and_use(fedora_obj, datastream = "Archival.xml")
      result = []
      accessrestrictps = fedora_obj.datastreams[datastream].find_by_terms_and_value(:accessrestrictp)
      userestrictps = fedora_obj.datastreams[datastream].find_by_terms_and_value(:userestrictp)
      preferciteps = fedora_obj.datastreams[datastream].find_by_terms_and_value(:prefercitep)

      accessrestrictps.each do |accessrestrictp|
        result << accessrestrictp.text
      end

      userestrictps.each do |userestrictp|
        result << userestrictp.text
      end

      # TBD -- do they want the prefercite?  It's not on the design drawings...
      preferciteps.each do |prefercitep|
        result << "Preferred citation: " + prefercitep.text
      end

      return result
    end


    def self.get_processing_notes(fedora_obj, datastream = "Archival.xml")
      result = []
      processinfos = fedora_obj.datastreams[datastream].find_by_terms_and_value(:processinfo)

      processinfos.each do |processinfo|
        result << processinfo.text
      end

      return result
    end


    def self.get_acquisition_info(fedora_obj, datastream = "Archival.xml")
      result = []
      acqinfos = fedora_obj.datastreams[datastream].find_by_terms_and_value(:acqinfo)

      acqinfos.each do |acqinfo|
        result << acqinfo.text
      end

      return result
    end


    def self.get_series(fedora_obj, item_id, datastream = "Archival.xml")
      series = nil
      series_level = 0
      subseries_level = 0
      serieses = fedora_obj.datastreams[datastream].find_by_terms_and_value(:series)

      # look for a c01 whose id matches item_id
      serieses.each do |item|
        series_level += 1
        subseries_level = 0

        if item.attribute("id").text == item_id
          series = item
        else
          # look for a c02 whose id matches item_id
          item.element_children.each do |element_child|
            if element_child.name == "c02"
              if element_child.attribute("level").text == "subseries"
                subseries_level += 1

                if element_child.attribute("id").text == item_id
                  series = element_child
                  break
                end
              end
            end
          end
        end

        if !series.nil?
          break
        end
      end

      return series, series_level.to_s + (subseries_level == 0 ? "" : ("." + subseries_level.to_s))
    end

    def self.get_series_info(series)
      did = nil
      scopecontent = nil
      unittitle = nil
      unitdate = nil
      physdesc = ""
      title = ""
      paragraphs = []
      series_restrict = nil

      if !series.nil?
        # find the pertinent child elements: did, scopecontent
        series.element_children.each do |element_child|
          if element_child.name == "did"
            did = element_child
          elsif element_child.name == "scopecontent"
            scopecontent = element_child
          elsif element_child.name == "accessrestrict"
            series_restrict = element_child.text
          end
        end

        # process the did element
        if !did.nil?
          did.element_children.each do |did_child|
            if did_child.name == "unittitle"
              unittitle = did_child.text
            elsif did_child.name == "unitdate"
              unitdate = did_child.text
            elsif did_child.name == "physdesc"
              physdesc = did_child.text
            end
          end
        end

        # process the scopecontent element
        paragraphs = get_scopecontent_paragraphs(scopecontent)

        title = (unittitle.nil? ? "" : unittitle + (unitdate.nil? ? "" : ", " + unitdate))
      end

      return title, physdesc, paragraphs, series_restrict
    end

    def self.get_series_items(series)
      result = []

      series.element_children.each do |series_child|
        child_name = series_child.name

        # The series could be a <c01 level="series"> with c02 children, or
        # it could be a <c02 level="subseries"> with c03 children.
        if child_name == "c02" || child_name == "c03"
          result << series_child
        end
      end

      return result
    end


    def self.get_series_item_info(item)
      title = ""
      paragraphs = []
      labels = ""
      values = ""
      next_level_items = []
      did = nil
      daogrp = nil
      scopecontent = nil
      unittitle = nil
      unitdate = nil
      physloc = nil
      physloc_orig = nil
      creator = ""
      page = nil
      thumbnail = nil
      access_restrict = nil
      available_online = false;

      item_id = item.attribute("id").text()
      item_type = item.attribute("level")

      item.element_children.each do |item_child|
        if item_child.name == "did"
          did = item_child
        elsif item_child.name == "daogrp"
          daogrp = item_child
        elsif item_child.name == "scopecontent"
          scopecontent = item_child
        elsif item_child.name == "accessrestrict"
          access_restrict = item_child.text
        elsif item_child.name == "c03" || item_child.name == "c04" ||
              item_child.name == "c05" || item_child.name == "c06" ||
              item_child.name == "c07" || item_child.name == "c08" ||
              item_child.name == "c09" || item_child.name == "c10" ||
              item_child.name == "c11" || item_child.name == "c12"
          next_level_items << item_child
        end
      end

      if !did.nil?
        did.element_children.each do |did_child|
          if did_child.name == "unittitle"
            unittitle = did_child.children.first.text

            if did_child.children.size > 1
              unittitle_child = did_child.children[1]

              if unittitle_child.name == "unitdate"
                unitdate = unittitle_child.text
              end
            end
          elsif did_child.name == "unitdate"
            unitdate = did_child.text
          elsif did_child.name == "physloc"
            physloc = did_child.text
            physloc_orig = did_child.text
          elsif did_child.name == "origination"
            did_child.children.each do |pers|
              if pers.name = "persname"
                creator += pers.text.strip
              end
            end

          end
        end
      end

      if !daogrp.nil?
        daogrp.element_children.each do |daogrp_child|
          if daogrp_child.name == "daoloc"
            daoloc_label = daogrp_child.attribute("label")
            daoloc_href = daogrp_child.attribute("href")
            daoloc_audience = daogrp_child.attribute("audience")

            if !daoloc_audience.nil? && daoloc_audience.text == "internal"
              # an audience="internal" attribute in a daoloc tag means this item is in the Dark Archive;
              # leave page and thumbnail = nil so that values will not be returned for them
              # and so that the href will not be included in title.  Set physloc to the dark
              # archive message.
              physloc = "Dark Archive; <a href=""/contact"">contact DCA</a>"
            elsif !daoloc_label.nil? && !daoloc_href.nil?
              daoloc_label_text = daoloc_label.text
              daoloc_href_text = daoloc_href.text

              if daoloc_label_text == "page"
                page = daoloc_href_text
              elsif daoloc_label_text == "thumbnail"
                thumbnail = daoloc_href_text
              end
            end
          end
        end
      end

      available_online = !page.nil? && !page.empty? && Tufts::PidMethods.ingested?(page)
      title = (available_online ? "<a href=\"/catalog/" + page + "\">" : "") + (unittitle.nil? ? "" : unittitle) + (unitdate.nil? || (!unittitle.nil? && unittitle.end_with?(unitdate))? "" : " " + unitdate) + (available_online ? "</a>" : "")

      if !physloc.nil?
        labels = "Location:"
        values = physloc
      end

      if !item_id.nil?
        if labels.size > 0
          labels << "<br>"
          values << "<br>"
        end
        labels << "ID:"
        values << item_id.to_s
      end

      if !item_type.nil?
        if labels.size > 0
          labels << "<br>"
          values << "<br>"
        end
        labels << "Type:"

        item_type_text = item_type.to_s

        if item_type_text == "item"
          values << "Item"
        elsif item_type_text == "file"
          values << "Folder"
        else
          values << item_type_text
        end
      end

      if !access_restrict.nil?
        if labels.size > 0
          labels << "<br>"
          values << "<br>"
        end
        labels << "Access:"
        values << access_restrict
      end

      paragraphs = get_scopecontent_paragraphs(scopecontent)

      return unitdate, creator, physloc_orig, access_restrict, item_id, title, paragraphs, labels, values, page, thumbnail, available_online, next_level_items
    end


    def self.get_series_access_and_use(series)
      result = []
      access_restrict = nil
      use_restrict = nil

      series.element_children.each do |series_child|
        if series_child.name == "accessrestrict"
          access_restrict = series_child
        elsif series_child.name == "userestrict"
          use_restrict = series_child
        end
      end

      if !access_restrict.nil?
        access_restrict.element_children.each do |access_child|
          if access_child.name == "p"
            result << access_child.text
          end
        end
      end

      if !use_restrict.nil?
        use_restrict.element_children.each do |use_child|
          if use_child.name == "p"
            result << use_child.text
          end
        end
      end

      return result
    end


    def self.parse_origination(node)
      name = nil
      rcr_url = nil

      first_element = node.first

      if !first_element.nil?
        name = first_element.text
        first_element_id = first_element.attribute("id")

        if !first_element_id.nil?
          rcr_url = first_element_id.text
        end
      end

      return name, rcr_url
    end


  end
end
