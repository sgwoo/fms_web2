/**
 * 블랙박스 관리
 * @ author : Kyungsuk Cho
 * @ e-mail : 
 * @ create date : 2016.12.22
 * @ last modify date : 
 */
package acar.blackbox;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.blackbox.*;

public class BlackBoxDatabase
{
    private Connection conn = null;
    public static BlackBoxDatabase db;
    
    public static BlackBoxDatabase getInstance()
    {
        if(BlackBoxDatabase.db == null)
            BlackBoxDatabase.db = new BlackBoxDatabase();
        return BlackBoxDatabase.db;
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
            System.out.println("I can't get a connection........");
        }
    }
    
    private void closeConnection()
    {
        if ( conn != null ) 
        {
            connMgr.freeConnection("acar", conn);
            conn = null;
        }       
    }
    
    /*
     * 블랙박스 모델 Bean 생성
     * */
    private BBModelBean makeBBModelBean(ResultSet results) throws DatabaseException {

        try {
            
            BBModelBean bean = new BBModelBean();
            
            bean.setModel_id(results.getString("MODEL_ID"));
            bean.setOff_id(results.getString("OFF_ID"));
            bean.setBidding_id(results.getString("BD_ID"));
            bean.setModel_nm(results.getString("MODEL_NM"));
            bean.setPrice(results.getInt("PRICE"));
            bean.setQuantity(results.getInt("QUANTITY"));
            bean.setSpec(results.getString("SPEC"));
            bean.setEtc(results.getString("ETC"));
            bean.setReg_dt(results.getString("REG_DT"));
            bean.setOff_nm(results.getString("OFF_NM"));
            bean.setSerial_num(results.getString("SERIAL_NUM"));
            
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
    }
    
    /**
    *   블랙박스 모델 정보 등록
    */
    public int insertModelInfo(BBModelBean bean){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int result = -1;
        String model_id = "";
        String query, query1 = "";

        query1= "SELECT NVL(LPAD(MAX(model_id)+1,6,'0'),'000001') FROM BB_MODEL";
        query = "INSERT INTO BB_MODEL"+
                "(MODEL_ID, OFF_ID, BD_ID, MODEL_NM, PRICE, QUANTITY, SPEC, ETC, REG_DT, OFF_NM)" +
                " VALUES"+
                "(?,?,?,?,?,?,?,?,sysdate,?)";
        try{
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query1);
            rs = pstmt.executeQuery();

            if(rs.next()){
                model_id = rs.getString(1);
            }
            
            pstmt = conn.prepareStatement(query);
            
            pstmt.setString(1, model_id.trim());
            pstmt.setString(2, bean.getOff_id());
            pstmt.setString(3, bean.getBidding_id());
            pstmt.setString(4, bean.getModel_nm());
            pstmt.setInt(5, bean.getPrice());
            pstmt.setInt(6, bean.getQuantity());
            pstmt.setString(7, bean.getSpec());
            pstmt.setString(8, bean.getEtc());
            pstmt.setString(9, bean.getOff_nm());
            
            result = pstmt.executeUpdate();
            
            rs.close();
            pstmt.close();
            conn.commit();

        }catch(Exception e){
            System.out.println("[BlackBoxDatabase:insertModelInfo(BBModelBean bean)]"+e);
            e.printStackTrace();
            conn.rollback();
        }finally{
            
            try{
                conn.setAutoCommit(true);
                if(rs != null) rs.close();
                        if(pstmt != null) pstmt.close();
                
            }catch(Exception ignore){}

            closeConnection();
            return result;
        }       
    }

    /*
     * 입찰 정보 등록
     * */
    public String insertBiddingInfo(int year, int count, String startDate, String endDate, String damdangId){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int result = -1;
        String bidding_id = "";
        String query, query1 = "";

        query1= "SELECT NVL(LPAD(MAX(BD_ID)+1,6,'0'),'000001') FROM BB_BIDDING";
        query = "INSERT INTO BB_BIDDING"+
                "(BD_ID, YEAR, CNT, START_DT, END_DT, DAMDANG_ID, REG_DT)" +
                " VALUES"+
                "(?,?,?,?,?,?,to_char(sysdate,'yyyymmddMMss'))";
        try{
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query1);
            rs = pstmt.executeQuery();

            if(rs.next()){
                bidding_id = rs.getString(1);
            }
            
            pstmt = conn.prepareStatement(query);
            
            pstmt.setString(1,bidding_id);
            pstmt.setInt(2, year);
            pstmt.setInt(3, count);
            pstmt.setString(4, startDate);
            pstmt.setString(5, endDate);
            pstmt.setString(6, damdangId);
          
            result = pstmt.executeUpdate();
            
            rs.close();
            pstmt.close();
            conn.commit();

        }catch(Exception e){
            System.out.println("[BlackBoxDatabase:insertBiddingInfo(int year, int count, String startDate, String endDate, String damdangId)]"+e);
            e.printStackTrace();
            conn.rollback();
        }finally{
            
            try{
                conn.setAutoCommit(true);
                if(rs != null) rs.close();
                        if(pstmt != null) pstmt.close();
                
            }catch(Exception ignore){}

            closeConnection();
            return bidding_id;
        }       
    }
    
    /**
    *  입찰 정보 조회
    */
   public Vector getBiddingList()
   {
       getConnection();
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       Vector vt = new Vector();

       String query =  " SELECT BD_ID, RL_ID, YEAR, CNT, DAMDANG_ID, REG_DT, START_DT, END_DT "+
                        "  FROM BB_BIDDING ";
       try {

           pstmt = conn.prepareStatement(query);
           rs = pstmt.executeQuery();
           ResultSetMetaData rsmd = rs.getMetaData();      
           while(rs.next())
           {               
               Hashtable ht = new Hashtable();
               for(int pos =1; pos <= rsmd.getColumnCount();pos++)
               {
                    String columnName = rsmd.getColumnName(pos);
                    ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
               }
               vt.add(ht); 
           }
			rs.close();
			pstmt.close();

       } catch (SQLException e) {
           System.out.println("[BlackBoxDatabase:getBiddingList]"+e);
           e.printStackTrace();
       } finally {
           try{
               if(rs != null )     rs.close();
               if(pstmt != null)   pstmt.close();
           }catch(Exception ignore){}
           closeConnection();
           return vt;
       }
   }   
   
   
   public Vector getModelList(String bidding_id){
       getConnection();
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       Vector vt = new Vector();
       String query =  " SELECT MODEL_ID, OFF_ID, MODEL_NM, PRICE, QUANTITY, SPEC, ETC, REG_DT, BD_ID, OFF_NM, SERIAL_NUM " + 
                       "   FROM BB_MODEL " +
                       "  WHERE BD_ID = '" + bidding_id + "'"; 
               

       try {

           pstmt = conn.prepareStatement(query);
           rs = pstmt.executeQuery();
           while(rs.next())
           {               
               BBModelBean bean = new BBModelBean();
               bean.setModel_id(rs.getString(1));
               bean.setOff_id(rs.getString(2));
               bean.setModel_nm(rs.getString(3));
               bean.setPrice(rs.getInt(4));
               bean.setQuantity(rs.getInt(5));
               bean.setSpec(rs.getString(6));
               bean.setEtc(rs.getString(7));
               bean.setReg_dt(rs.getString(8));
               bean.setBidding_id(rs.getString(9));
               bean.setOff_nm(rs.getString(10));
               bean.setSerial_num(rs.getString(11));
               
               vt.add(bean);   
           }
			rs.close();
			pstmt.close();

       } catch (SQLException e) {
           System.out.println("[BlackBoxDatabase:getModelList(String bidding_id)]"+e);
           e.printStackTrace();
       } finally {
           try{
               if(rs != null )     rs.close();
               if(pstmt != null)   pstmt.close();
           }catch(Exception ignore){}
           closeConnection();
           return vt;
       }
   }
   
   //협력업체 이름으로 블랙박스 모델 검색하기
   public BBModelBean[] getModelListByOffName(String off_name){
       getConnection();
       PreparedStatement pstmt = null;
       Collection<BBModelBean> col = new ArrayList<BBModelBean>();
       
       ResultSet rs = null;
       Vector vt = new Vector();
       String query =  " SELECT MODEL_ID, OFF_ID, MODEL_NM, PRICE, QUANTITY, SPEC, ETC, REG_DT, BD_ID, OFF_NM, SERIAL_NUM " + 
                       "   FROM BB_MODEL" +
                       "  WHERE OFF_NM LIKE '%" + off_name + "%'" + 
                       "  ORDER BY MODEL_ID DESC " ;
               

       try {

           pstmt = conn.prepareStatement(query);
           rs = pstmt.executeQuery();
          
           while(rs.next())
           {               
               col.add(makeBBModelBean(rs));
           }
			rs.close();
			pstmt.close();

       } catch (SQLException e) {
           System.out.println("[BlackBoxDatabase:getModelList(String bidding_id)]"+e);
           e.printStackTrace();
       } finally {
           try{
               if(rs != null )     rs.close();
               if(pstmt != null)   pstmt.close();
           }catch(Exception ignore){}
           closeConnection();
           return (BBModelBean[])col.toArray(new BBModelBean[0]);
       }
   }
}