package acar.util;
 
import java.io.FileWriter;  // xml 파일을 생성하려고...
import java.io.IOException; // io 예외처리를 위해.
 
import java.util.ArrayList; // 데이터들을 담는 list만들어줌.

import java.sql.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

import org.dom4j.Document;  // 문서
import org.dom4j.DocumentHelper; // Document 를 생성하기 위한 도움 클래스.
import org.dom4j.Element;  //xml 의 요소
import org.dom4j.io.OutputFormat; // 파일이 생성될 시 출력 포맷을 컨트롤.
import org.dom4j.io.XMLWriter;  // 드디어 xml 파일 생성할때 쓰는 클래스.
 
import acar.beans.XmlMenuBean; 
 
public class CreateXML {
    private XmlMenuBean xmenu = new XmlMenuBean(); 
     
    private static Document createDocument() throws Exception {
        Document document = DocumentHelper.createDocument();
        Element root = document.addElement("system");

        ArrayList<XmlMenuBean> list = getResultList();
         
        for(int i = 0; i < list.size(); i++)
        {
            Element superNod = root.addElement("ResultSet");
            XmlMenuBean xmenu = list.get(i);
             
            Element element = superNod.addElement("m_st");
            element.addText(xmenu.getM_st());
             
            element = superNod.addElement("m_st2");
            element.addText(xmenu.getM_st2());
             
            element = superNod.addElement("m_cd");
            element.addText(xmenu.getM_cd());
             
            element = superNod.addElement("m_nm");
            element.addText(xmenu.getM_nm());
             
            element = superNod.addElement("url");
            element.addText(xmenu.getUrl());
                          
            element = superNod.addElement("seq");
            element.addText(Integer.toString(xmenu.getSeq()));
        }        
        return document;
    } 
     
     
    public static ArrayList<XmlMenuBean> getResultList()
    {
    		    		
		  DBConnectionManager connMgr = null;
				
        ArrayList<XmlMenuBean> list = new ArrayList<XmlMenuBean>(); 	        
 	
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
       String query = "SELECT m_st, m_st2, m_cd, m_nm, url, seq  FROM xml_menu order by 1, 2, seq ";
       
        try {
            connMgr = DBConnectionManager.getInstance();
		  	  conn = connMgr.getConnection("acar");
            
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
                      
            while(rs.next())
            {
                XmlMenuBean xmenu = new XmlMenuBean();
                
                xmenu.setM_st(rs.getString("m_st"));
                xmenu.setM_st2(rs.getString("m_st2"));
                xmenu.setM_cd(rs.getString("m_cd"));
                xmenu.setM_nm(rs.getString("m_nm"));
                xmenu.setUrl(rs.getString("url"));
                xmenu.setSeq(rs.getInt("seq"));
                       
                list.add(xmenu);
            }
             
        } catch (Exception sqle) {
            sqle.printStackTrace();
        }
 
        return list;
    }
     
    public static void makeXml() {
        Document document;
        try {
            document = createDocument();
            OutputFormat format = new OutputFormat("\t", true);
             
            FileWriter out = new FileWriter("/httpd/www/xml/output.xml"); // 저장 원하는 위치
            XMLWriter writer = new XMLWriter(out, format);
            writer.write(document);
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
