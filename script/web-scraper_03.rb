#!/usr/bin/env ruby

require 'rubygems'
require 'watir-webdriver'
require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'


$username = ''
$password = ''
$xmlHash = Hash.new()
$xmlHash['courses'] = Array.new

if ARGV.length == 2
    $username = ARGV[0]
    $password = ARGV[1]
end


class MyDocument < Nokogiri::XML::SAX::Document

def start_element(name,attrs=[])
    if name == 'span'
        puts attrs['id']
    end 
end
end



def outputHTML(filename, page_html)

    File.open(filename, 'w') do |f|
        f.puts page_html
    end

end


def findSingleHtmlElement(doc, id, count)

    xpathString = "//span[starts-with(@id,'#{id}')]"
    counter = 0

    doc.xpath(xpathString).each do |node|
        if counter == count
            return node.content
        end
        counter += 1
    end
    
end

def is_integer?(str)
    Integer(str)
rescue ArgumentError
    false
else
    true
end


def writeSectionToXML(doc)
   
    sectionHash = Hash.new()
    sectionHash['sectionname']       = findSingleHtmlElement(doc, 'DERIVED_CLSRCH_DESCR200', 0)
    sectionHash['shortdescription']  = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_SSR_DESCRSHORT', 0)
    sectionHash['classnumber']       = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_CLASS_NBR', 0)
    sectionHash['session']           = findSingleHtmlElement(doc, 'PSXLATITEM_XLATLONGNAME$55$', 0)
    sectionHash['units']             = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_UNITS_RANGE', 0)
    sectionHash['classcomponents']   = Array.new
    sectionHash['classcomponents']   << findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_DESCR', 0)
    sectionHash['classcomponents']   << findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_DESCRSHORT', 0) 
    sectionHash['career']            = findSingleHtmlElement(doc, 'PSXLATITEM_XLATLONGNAME', 0)
    sectionHash['datelong']          = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_SSR_DATE_LONG', 0)
    sectionHash['grading']           = findSingleHtmlElement(doc, 'GRADE_BASIS_TBL_DESCRFORMAL', 0)
    sectionHash['city']              = findSingleHtmlElement(doc, 'CAMPUS_LOC_VW_DESCR', 0)
    sectionHash['university']        = findSingleHtmlElement(doc, 'CAMPUS_TBL_DESCR', 0)
    sectionHash['topic']             = findSingleHtmlElement(doc, 'CRSE_TOPICS_DESCR', 0)
    sectionHash['time']              = findSingleHtmlElement(doc, 'MTG_SCHED', 0)
    sectionHash['location']          = findSingleHtmlElement(doc, 'MTG_LOC', 0)
    sectionHash['professor']         = findSingleHtmlElement(doc, 'MTG_INSTR', 0)
    sectionHash['dates']             = findSingleHtmlElement(doc, 'MTG_DATE', 0)
    sectionHash['enrollrequirement'] = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_SSR_REQUISITE_LONG', 0)
    sectionHash['aoks']              = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_SSR_CRSE_ATTR_LONG', 0)
    if not is_integer?(sectionHash['aoks'])
        sectionHash['aoks'] = sectionHash['aoks'].split(/\n/)
    end
    sectionHash['sectioncapacity']   = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_ENRL_CAP', 0)
    sectionHash['waitlistcapacity']  = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_WAIT_CAP', 0)
    sectionHash['sectiontotal']      = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_ENRL_TOT', 0)
    sectionHash['waitlisttotal']     = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_WAIT_TOT', 0)
    sectionHash['availableseats']    = findSingleHtmlElement(doc, 'SSR_CLS_DTL_WRK_AVAILABLE_SEATS', 0)

=begin
    doc.xpath("//span[substring-before(@id,'$') = 'CLASS_NAME'
        and substring-after(@id, '$') >= 0
        iand substring-after(@id, '$') <= 999999]").each do |node|
            sectionHash['details'] = node.content
            puts node.content
    end
    doc.xpath("//span[substring-before(@id,'$') = 'DERIVED_CLS_CMB_DESCR'
        and substring-after(@id, '$') >= 0
        and substring-after(@id, '$') <= 999999]").each do |node|
            sectionHash['description'] = node.content
            puts node.content
    end
 
    doc.xpath("//span[substring-before(@id,'$') = 'MTG_SCHED'
        and substring-after(@id, '$') >= 0
        and substring-after(@id, '$') <= 999999]").each do |node|
            sectionHash['time'] = node.content
            puts node.content
    end
=end
    return sectionHash

end


def createCourseHash(subject, counter)

    f = File.open('temp.html')
    doc = Nokogiri::HTML(f)

    courseHash = Hash.new()
    courseHash['newNumber'] = subject + findSingleHtmlElement(doc,'DU_SS_SUBJ_CAT_CATALOG_NBR', counter) 
    courseHash['name']      = findSingleHtmlElement(doc, 'DU_SS_SUBJ_CAT_DESCR', counter)
#    courseHash['oldNumber'] = findSingleHtmlElement(doc, 'DERIVED_SSS_BCC_DESCR', counter)
    courseHash['sections'] = Array.new   
    pp courseHash 
    return courseHash

end




def writeXml()

    f = File.open('data.xml','a+')

    builder = Nokogiri::XML::Builder.new do |xml|
    xml.courses {
        $xmlHash['courses'].each do |courseHash|
            xml.course {
                xml.newNumber_   courseHash['newNumber']
                xml.name_        courseHash['name']
                xml.sections {
                    courseHash['sections'].each do |sectionHash|
                        xml.section {
                            xml.sectionname_    sectionHash['sectionname']
                            xml.time_           sectionHash['time']
                            xml.location_       sectionHash['location']
                            xml.professor_      sectionHash['professor']
                            xml.areasOfKnowledge {
                                if not is_integer?(sectionHash['aoks'])
                                    sectionHash['aoks'].each do |aok|
                                        xml.areaOfKnowledge_    aok    
                                    end
                                else
                                    xml.areaOfKnowledge_   sectionHash['aoks']
                                end        
                            }
                            xml.sectioncapacity     sectionHash['sectioncapacity']
                            xml.waitlistcapacity    sectionHash['waitlistcapacity']
                            xml.sectiontotal        sectionHash['sectiontotal']
                            xml.waitlisttotal       sectionHash['waitlisttotal']
                            xml.availableseats      sectionHash['availableseats']
                        }
                    end
                }  
            }
        end
    }
    end

    File.open('data.xml', 'a+') do |f|
        f.puts builder.to_xml
    end

end 





# Main
def main()
    browser = Watir::Browser.new :ff
    begin
        browser.goto "http://aces.duke.edu/"
        browser.text_field(:id, "j_username").set($username)
        browser.text_field(:id, "j_password").set($password)
        Watir::Wait.until {browser.button(:name, "Submit").exists? }
        browser.button(:name, "Submit").click
#        sleep 5
        Watir::Wait.until {browser.link(:text, "Registration").exists? }
        browser.link(:text, "Registration").click
#        sleep 5
        page_html = Nokogiri::HTML.parse(browser.frame(:name, "TargetContent").html)
        outputHTML('temp.html',page_html)
        f= File.open('temp.html')

        doc = Nokogiri::HTML(f)
        f.close
        letters = Array.new
        doc.xpath("//div[starts-with(@id, 'win0divSSR_CLSRCH_WRK2_SSR_ALPHANUM_')]").each do |node|
            letters << node['id']
        end

        # Loop through A - Z
        letters.each do |link|
            link.slice! "win0div"
            puts link

 #           begin    
 #               Watir::Wait.until {browser.link(:id, link).exists?}
 #           rescue
 #               retry
 #           end
            begin
                browser.frame(:name, "TargetContent").link(:id, link).click
            rescue
                sleep 1
                retry
            end 
            sleep 1
                            
            page_html = Nokogiri::HTML.parse(browser.frame(:name, "TargetContent").html)
            outputHTML('temp.html',page_html)
            f= File.open('temp.html')
            doc = Nokogiri::HTML(f)
            f.close
            subjects = Array.new

            doc.xpath("//div[substring-before(@id,'$') = 'win0divDU_SEARCH_WRK_SSR_EXPAND_COLLAP2'
                and substring-after(@id, '$') >= 0
                and substring-after(@id, '$') <= 999999]").each do |node|
                    subjects << node['id']
            end

            if subjects.length == 0
                next
            end

            index = 0           
            index2 = 0
            # Loop through subjects 
            subjects.each do |sublink|
                        
                sublink.slice! "win0div"
                puts sublink
#                begin    
#                    Watir::Wait.until {browser.frame.link(:id, sublink).exists?}
#                rescue
#                    next
#                end
                begin
                    browser.frame(:name, "TargetContent").link(:id, sublink).click
                rescue
                    sleep 1
                    browser.frame(:name, "TargetContent").link(:id, link).click
                    sleep 3
                    browser.frame(:name, "TargetContent").link(:id, link).click
                    sleep 1
                    retry
                end
                sleep 1
       
 
                page_html = Nokogiri::HTML.parse(browser.frame(:name, "TargetContent").html)
                outputHTML('temp.html', page_html)

                f = File.open('temp.html')
#                parser = Nokogiri::XML::SAX::Parser.new(MyDocument.new)
#                parser.parse(f)

                doc = Nokogiri::HTML(f)
                f.close

                subject = findSingleHtmlElement(doc, 'SSR_CLSRCH_SUBJ_SUBJECT', index2)
                index2 += 1

                courses = Array.new
                doc.xpath("//div[substring-before(@id,'$') = 'win0divDU_SEARCH_WRK_SSR_EXPAND_COLLAPS'
                        and substring-after(@id, '$') >= #{index}
                        and substring-after(@id, '$') <= 999999]").each do |node|
                    courses << node['id']
                    index += 1
                end
                counter = 0
                puts courses 

                if courses.length == 0
                    next
                end
            
                # Loop through courses
                courses.each do |classlink|

                    classlink.slice! "win0div"
#                    begin    
#                        Watir::Wait.until {browser.frame.link(:id, classlink).exists?}
#                    rescue
#                        next
#                    end
                    begin 
                        browser.frame(:name, "TargetContent").link(:id, classlink).click
                    rescue
                        sleep 1
                        browser.frame(:name, "TargetContent").link(:id, sublink).click
                        sleep 3
                        browser.frame(:name, "TargetContent").link(:id, sublink).click
                        sleep 1
                        retry
                    end
                    sleep 1
                    page_html = Nokogiri::HTML.parse(
                        browser.frame(:name, "TargetContent").html)
                    outputHTML('temp.html', page_html)
                    f = File.open('temp.html')
                    doc = Nokogiri::HTML(f)        
                    f.close

                    courseHash = createCourseHash(subject, counter)
                    $xmlHash['courses'] << courseHash
                    counter += 1
                    sections = Array.new
                    doc.xpath("//div[substring-before(@id,'$') = 'win0divCLASS_DETAIL'
                        and substring-after(@id, '$') >= 0
                        and substring-after(@id, '$') <= 999999]").each do |node|
                            sections << node['id']
                    end
                    pp sections

                    if sections.length == 0
                        next
                    end
 
                    sections.each do |sectionlink|

                        sectionlink.slice! "win0div"
#                        begin    
#                            Watir::Wait.until {browser.frame.link(:id, sectionlink).exists?}
#                        rescue
#                            next
#                        end
#
                        begin
                            browser.frame(:name, "TargetContent").link(:id, sectionlink).click
                        rescue
                            sleep 1
                            browser.frame(:name, "TargetContent").link(:id, classlink).click
                            sleep 3
                            browser.frame(:name, "TargetContent").link(:id, classlink).click
                            sleep 1
                            retry
                        end
                        sleep 1

                        page_html = Nokogiri::HTML.parse(
                            browser.frame(:name, "TargetContent").html)
                        outputHTML('temp.html', page_html) 
                        f = File.open('temp.html')
                        doc = Nokogiri::HTML(f)        
 
                        courseHash['sections'] << writeSectionToXML(doc)
                        pp courseHash['sections']

#                        begin    
#                            Watir::Wait.until {browser.frame.link(:id, "CLASS_SRCH_WRK2_SSR_PB_CLOSE").exists?}
#                        rescue
#                            next
#                        end
#
                        while true
                            begin
                                browser.frame(:name, "TargetContent").link(:id, "CLASS_SRCH_WRK2_SSR_PB_CLOSE").click
                                break
                            rescue
                                sleep 5
                                retry
                            end
                        end
                            
                        sleep 1

#                        browser.close 
#                        exit
#                        break
                    end

#                    break
                    while true
                        begin
                            browser.frame(:name, "TargetContent").link(:id, classlink).click
                            break
                        rescue
                            sleep 5
                            retry
                        end
                    end
                    sleep 1
                end      

                while true
                    begin
                        browser.frame(:name, "TargetContent").link(:id, sublink).click
                        break
                    rescue
                        sleep 5
                        retry
                    end
                end
                sleep 1
#                break          

            end
    
#            break
        end

        browser.close
    rescue => e
        puts e.inspect
        puts e.backtrace
        browser.close
    end

end 





begin 
    main()
    writeXml()
rescue => e
    puts e.inspect
    puts e.backtrace
end 
