package acar.kakao;


import acar.database.*;

import java.sql.*;
import java.util.*;

/*
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;
*/

public class AlimTemplateDatabase {

    private static final String ORG_NAME = "아마존카";
    private static final String ORG_UUID = "@아마존카";

    private Connection conn = null;
    public static AlimTemplateDatabase db;

    public static AlimTemplateDatabase getInstance()
    {
        if(AlimTemplateDatabase.db == null)
            AlimTemplateDatabase.db = new AlimTemplateDatabase();
        return AlimTemplateDatabase.db;
    }

    private DBConnectionManager connMgr = null;

    private void getConnection()
    {
        try
        {
            if(connMgr == null)
                connMgr = DBConnectionManager.getInstance();
            if(conn == null)
                conn = connMgr.getConnection("acar");
        }catch(Exception e){
            System.out.println(" i can't get a connection........");
        }
    }

    private void closeConnection()
    {
        if ( conn != null )
        {
            connMgr.freeConnection("acar", conn);
        }
    }

     public int sequence() {
      
        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;
		  int seq = 0;
		  
        String query =
                "SELECT MAX(no) + 1 seq FROM ata_template";

        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                seq = rs.getInt("SEQ");
            }
            rs.close();
			   pstmt.close();  
        }
        catch (Exception e) {
            System.out.println("[AlimTemplateDatabase:sequence()]\n"+e);
            e.printStackTrace();
        }finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();			
			return seq;
		}
	}
        
     
    // 템플릿 리스트 가져옴
    public List<AlimTemplateBean> selectTemplateList(String category_1, String category, boolean showList) {
    	
        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        List<AlimTemplateBean> templateBeanList = new ArrayList<AlimTemplateBean>();

        String where = "";
        
        if (!category.equals("0")) {
            /*where += " AND CAT = '"+ category +"' ";*/
        	if (category_1.equals("1")) {        		
        		//where += " AND CAT_1 = '"+ category_1 +"'" + " AND CAT = '"+ category +"' ";
        		where += " AND CAT_1 = '"+ category +"' ";
        	} else if (category_1.equals("2")) {
        		where += " AND CAT = '"+ category +"' ";
        	}
        } else if (!category_1.equals("0") && category.equals("0")) {
        	where += " AND CAT_1 = '99' AND CAT = '99' ";
        }
        
        if (showList == true) {
            where += " AND SHOW_LIST = 'Y' and use_yn='Y' ";
        }

        String query =
                "SELECT NO, CAT_1, CAT, SHOW_LIST, CODE, NAME, CONTENT, ORG_NAME, ORG_UUID, DESCRIPTION, USE_YN, M_NM " +
                "FROM ATA_TEMPLATE WHERE 1=1 " + where +
                "ORDER BY NO";

		// System.out.println(" template query = " +  query );
			  
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                AlimTemplateBean templateBean = new AlimTemplateBean();

                templateBean.setNo(rs.getInt("NO"));
                templateBean.setCategory_1(rs.getString("CAT_1"));
                templateBean.setCategory(rs.getString("CAT"));
                templateBean.setShowList(rs.getString("SHOW_LIST"));
                templateBean.setCode(rs.getString("CODE"));
                templateBean.setName(rs.getString("NAME"));
                templateBean.setContent(rs.getString("CONTENT"));
                templateBean.setOrg_name(rs.getString("ORG_NAME"));
                templateBean.setOrg_uuid(rs.getString("ORG_UUID"));
                templateBean.setDesc(rs.getString("DESCRIPTION"));
				templateBean.setUse_yn(rs.getString("USE_YN"));
				templateBean.setM_nm(rs.getString("M_NM"));

                templateBeanList.add(templateBean);
            }
             rs.close();
			   pstmt.close();  
        }     
        catch (Exception e) {
            System.out.println("[AlimTemplateDatabase:selectTemplateList()]\n"+e);
            e.printStackTrace();
        } finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			
			return templateBeanList;
		}		
    }
    
    // 템플릿 리스트 가져옴
    public List<AlimTemplateBean> selectNewTemplateList(String m_nm, boolean showList) {
    	
    	getConnection();
    	
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	
    	List<AlimTemplateBean> templateBeanList = new ArrayList<AlimTemplateBean>();
    	
    	String where_and = "";
    	
    	/*if (!category.equals("0")) {
    		where += " AND CAT = '"+ category +"' ";
    		if (category_1.equals("1")) {        		
    			//where += " AND CAT_1 = '"+ category_1 +"'" + " AND CAT = '"+ category +"' ";
    			where_and += " AND CAT_1 = '"+ category +"' ";
    		} else if (category_1.equals("2")) {
    			where_and += " AND CAT = '"+ category +"' ";
    		}
    	} else if (!category_1.equals("0") && category.equals("0")) {
    		where_and += " AND CAT_1 = '99' AND CAT = '99' ";
    	}*/
    	
    	if (showList == true) {
    		where_and += " AND SHOW_LIST = 'Y' and use_yn='Y' ";
    	}
    	
    	String query = " SELECT * FROM ATA_TEMPLATE " +
    							" WHERE 1=1 " + 
    							" AND M_NM like '%"+m_nm+"%' " +
    							where_and +
    							" ORDER BY NO ";
    	
    	//System.out.println(" template query = " +  query );
    	
    	try {
    		pstmt = conn.prepareStatement(query);
    		rs = pstmt.executeQuery();
    		while (rs.next()) {
    			AlimTemplateBean templateBean = new AlimTemplateBean();
    			
    			templateBean.setNo(rs.getInt("NO"));
    			templateBean.setCategory_1(rs.getString("CAT_1"));
    			templateBean.setCategory(rs.getString("CAT"));
    			templateBean.setShowList(rs.getString("SHOW_LIST"));
    			templateBean.setCode(rs.getString("CODE"));
    			templateBean.setName(rs.getString("NAME"));
    			templateBean.setContent(rs.getString("CONTENT"));
    			templateBean.setOrg_name(rs.getString("ORG_NAME"));
    			templateBean.setOrg_uuid(rs.getString("ORG_UUID"));
    			templateBean.setDesc(rs.getString("DESCRIPTION"));
    			templateBean.setUse_yn(rs.getString("USE_YN"));
    			templateBean.setM_nm(rs.getString("M_NM"));
    			
    			templateBeanList.add(templateBean);
    		}
    		rs.close();
    		pstmt.close();  
    	}     
    	catch (Exception e) {
    		System.out.println("[AlimTemplateDatabase:selectNewTemplateList()]\n"+e);
    		e.printStackTrace();
    	} finally {
    		try{
    			if (rs != null ) {
    				rs.close();
    			}
    			if (pstmt != null) {
    				pstmt.close();
    			}
    		}catch(Exception ignore){}    		
    		closeConnection();    		
    		return templateBeanList;
    	}		
    }
    
    // 템플릿 리스트 가져옴(사용 여부, 관리여 부 추가) 	2017.12.21
    public List<AlimTemplateBean> selectTemplateList2(String category_1, String category, String cmd_use, String cmd_manage) {
     
        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        List<AlimTemplateBean> templateBeanList = new ArrayList<AlimTemplateBean>();

        String where = "";
        /*if(category.equals("0") == false) {
            where += " AND CAT = '"+ category +"' ";
        }*/
        
        if (!category.equals("0")) {
            /*where += " AND CAT = '"+ category +"' ";*/
        	if (category_1.equals("1")) {        		
        		//where += " AND CAT_1 = '"+ category_1 +"'" + " AND CAT = '"+ category +"' ";
        		where += " AND CAT_1 = '"+ category +"' ";
        	} else if (category_1.equals("2")) {
        		where += " AND CAT = '"+ category +"' ";
        	}
        } else if (!category_1.equals("0") && category.equals("0")) {
        	where += " AND CAT_1 = '99' AND CAT = '99' ";
        }
        
        if(cmd_use.equals("2")){
        }else if(cmd_use.equals("1")){
        	where += " AND USE_YN = 'Y' ";
        }else if(cmd_use.equals("0")){
        	where += " AND USE_YN = 'N' ";
        }
        
        if(cmd_manage.equals("2")){
        }else if(cmd_manage.equals("1")){
        	where += " AND SHOW_LIST = 'Y' ";
        }else if(cmd_manage.equals("0")){
        	where += " AND SHOW_LIST = 'N' ";
        }

        String query =
                "SELECT NO, CAT_1, CAT, SHOW_LIST, CODE, NAME, CONTENT, ORG_NAME, ORG_UUID, DESCRIPTION, USE_YN, M_NM " +
                "FROM ATA_TEMPLATE WHERE 1=1" + where +
                "ORDER BY NO";
        
        // System.out.println(" template query = " +  query );
			  
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                AlimTemplateBean templateBean = new AlimTemplateBean();

                templateBean.setNo(rs.getInt("NO"));
                templateBean.setCategory_1(rs.getString("CAT_1"));
                templateBean.setCategory(rs.getString("CAT"));
                templateBean.setShowList(rs.getString("SHOW_LIST"));
                templateBean.setCode(rs.getString("CODE"));
                templateBean.setName(rs.getString("NAME"));
                templateBean.setContent(rs.getString("CONTENT"));
                templateBean.setOrg_name(rs.getString("ORG_NAME"));
                templateBean.setOrg_uuid(rs.getString("ORG_UUID"));
                templateBean.setDesc(rs.getString("DESCRIPTION"));
				templateBean.setUse_yn(rs.getString("USE_YN"));
				templateBean.setM_nm(rs.getString("M_NM"));

                templateBeanList.add(templateBean);
            }
             rs.close();
			   pstmt.close();  
        }     
        catch (Exception e) {
            System.out.println("[AlimTemplateDatabase:selectTemplateList2()]\n"+e);
            e.printStackTrace();
        } finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			
			return templateBeanList;
		}		
    }
        
      // 템플릿 리스트 가져옴 - 로그는 use_yn = 'Y' 인걸 대상으로 함 
    public List<AlimTemplateBean> selectTemplateLogList(String category_1, String category, boolean showList) {
     
        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        List<AlimTemplateBean> templateBeanList = new ArrayList<AlimTemplateBean>();

        String where = "";
        /*if (category.equals("0") == false) {
            where += " AND CAT = '"+ category +"' ";
        }*/
        if (!category.equals("0")) {
        	if (category_1.equals("1")) {
        		where += " AND CAT_1 = '"+ category +"' ";
        	} else if (category_1.equals("2")) {
        		where += " AND CAT = '"+ category +"' ";
        	}
        } else if (!category_1.equals("0") && category.equals("0")) {
        	where += " AND CAT_1 = '99' AND CAT = '99' ";
        }
        
        if (showList == true) {
            where += " AND SHOW_LIST  in ( 'Y' , 'N' )  and use_yn  in ('Y' )  ";
        }

        String query =
                "SELECT NO, CAT_1, CAT, SHOW_LIST, CODE, NAME, CONTENT, ORG_NAME, ORG_UUID, DESCRIPTION, USE_YN, M_NM " +
                "FROM ATA_TEMPLATE WHERE 1=1 " + where +
                "ORDER BY NO";

	//	  System.out.println("log template query = " +  query );
		  
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                AlimTemplateBean templateBean = new AlimTemplateBean();

                templateBean.setNo(rs.getInt("NO"));
                templateBean.setCategory_1(rs.getString("CAT_1"));
                templateBean.setCategory(rs.getString("CAT"));
                templateBean.setShowList(rs.getString("SHOW_LIST"));
                templateBean.setCode(rs.getString("CODE"));
                templateBean.setName(rs.getString("NAME"));
                templateBean.setContent(rs.getString("CONTENT"));
                templateBean.setOrg_name(rs.getString("ORG_NAME"));
                templateBean.setOrg_uuid(rs.getString("ORG_UUID"));
                templateBean.setDesc(rs.getString("DESCRIPTION"));
				templateBean.setUse_yn(rs.getString("USE_YN"));
				templateBean.setM_nm(rs.getString("M_NM"));

                templateBeanList.add(templateBean);
            }
             rs.close();
			   pstmt.close();  
        }     
        catch (Exception e) {
            System.out.println("[AlimTemplateDatabase:selectTemplateLogList()]\n"+e);
            e.printStackTrace();
        } finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			
			return templateBeanList;
		}		
    }
    
    	    

    // 템플릿 한건 가져옴
    public AlimTemplateBean selectTemplate(String tplCode) {
        getConnection();

		  AlimTemplateBean templateBean = new AlimTemplateBean();
		   
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String query =
                "SELECT NO, CODE, NAME, CONTENT, ORG_NAME, ORG_UUID, DESCRIPTION " +
                        "FROM ATA_TEMPLATE WHERE CODE = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, tplCode);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                templateBean.setNo(rs.getInt("NO"));
                templateBean.setCode(rs.getString("CODE"));
                templateBean.setName(rs.getString("NAME"));
                templateBean.setContent(rs.getString("CONTENT"));
                templateBean.setOrg_name(rs.getString("ORG_NAME"));

                templateBean.setOrg_uuid(rs.getString("ORG_UUID"));
                templateBean.setDesc(rs.getString("DESCRIPTION"));
            }
             rs.close();
			   pstmt.close();  
            
         }
        	catch (Exception e) {
            System.out.println("[AlimTemplateDatabase:selectTemplate()]\n"+e);
            e.printStackTrace();
         } finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
				closeConnection();
			
				return templateBean;
			}		
   
    }


    // 템플릿 등록
    public int insertTemplate(AlimTemplateBean template)
    {
        getConnection();

        PreparedStatement pstmt = null;
        int result = 0;

        String query =
                "INSERT INTO ATA_TEMPLATE ( " +
                    "NO, CAT_1, CAT, SHOW_LIST, CODE, NAME, " +
                    "CONTENT, ORG_NAME, ORG_UUID, DESCRIPTION, USE_YN, M_NM " +
                ")" +
                "VALUES ( " +
                    "?, ?, ?, ?, ?, ?, " +
                    "?, ?, ?, ?, ?, ?  " +
                ")";

        try
        {
        	  conn.setAutoCommit(false);
        	  	
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, template.getNo());
            pstmt.setString(2, template.getCategory_1());
            pstmt.setString(3, template.getCategory());
            pstmt.setString(4, template.getShowList());
            pstmt.setString(5, template.getCode());
            pstmt.setString(6, template.getName());
            pstmt.setString(7, template.getContent());
            pstmt.setString(8, ORG_NAME);
            pstmt.setString(9, ORG_UUID);
            pstmt.setString(10, template.getDesc());
            pstmt.setString(11,template.getUse_yn());
            pstmt.setString(12,template.getM_nm());

            result = pstmt.executeUpdate();
		      pstmt.close();
			
			  conn.commit();

 		} catch (Exception e) {
			System.out.println("[AlimTemplateDatabase:insertTemplate(AlimTemplateBean template) ]"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{					
             if(pstmt != null)	pstmt.close();
               
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}			
	}
		

    // 템플릿 변경
    public int updateTemplate(AlimTemplateBean template)
    {
        getConnection();

        PreparedStatement pstmt = null;
        int result = 0;

        String query =
                "UPDATE ATA_TEMPLATE SET " +
                    "CAT_1 = ?, " +
                    "CAT = ?, " +
                    "SHOW_LIST = ?, " +
                    "NAME = ?, " +
                    "CONTENT = ?, " +
                    "DESCRIPTION = ?, " +
                    "USE_YN = ?, " +
                    "M_NM = ? " +
                "WHERE NO = ? AND CODE = ?";

        try
        {
	        	conn.setAutoCommit(false);


            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, template.getCategory_1());
            pstmt.setString(2, template.getCategory());
            pstmt.setString(3, template.getShowList());
            pstmt.setString(4, template.getName());
            pstmt.setString(5, template.getContent());
            pstmt.setString(6, template.getDesc());
            pstmt.setString(7, template.getUse_yn());
            pstmt.setString(8, template.getM_nm());
            pstmt.setInt(9, template.getNo());
            pstmt.setString(10, template.getCode());

            result = pstmt.executeUpdate();
            pstmt.close();
			
			  conn.commit();

 		} catch (Exception e) {
			System.out.println("[AlimTemplateDatabase:updateTemplate(AlimTemplateBean template) ]"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{					
             if(pstmt != null)	pstmt.close();
               
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}			
	}
			

    // 템플릿 삭제
    public int deleteTemplate(int no, String code)
    {
        getConnection();

        PreparedStatement pstmt = null;
        int result = 0;

        String query =
                "DELETE FROM ATA_TEMPLATE WHERE NO = ? AND CODE = ?";
        try
        {
        	  conn.setAutoCommit(false);
        		
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, no);
            pstmt.setString(2, code);

            result = pstmt.executeUpdate();
            pstmt.close();
          
        	conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AlimTemplateDatabase:deleteTemplate(Int no, String code) ]"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{					
             if(pstmt != null)	pstmt.close();
               
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}			
	}
 

}
