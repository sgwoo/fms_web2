<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<%@ page import="acar.asset.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body style="font-size:12">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
         String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");	
		
	String mode 	= request.getParameter("mode")==null? "":request.getParameter("mode");
	String s_type 	= request.getParameter("s_type")==null? "":request.getParameter("s_type"); //1:지급액 또는 2:실적
		
	String s_flag = "";
	String s_flag4 = "";
	
	int flag = 0;
	int count = 0;
	int flag12 = 0;
	
	String today = AddUtil.getDate(4);
//	String today ="20120808";
	String save_dt = today;
		
	if(mode.equals("12"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type );//마감 중복 확인		
		
		if(flag12 == 0){
		
			if ( s_type.equals("1") ) {
			  //영업캠페인수당 등록
				Vector feedps = ad_db.getStatCampSale(today);
				int feedp_size = feedps.size();
						
				for (int i = 0 ; i < feedp_size ; i++){
					Hashtable feedp = (Hashtable)feedps.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);				
					
					bean.setSeq(i+1);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp.get("BUS_ID")));
					bean.setAmt(AddUtil.parseInt(String.valueOf(feedp.get("AMT"))));
					bean.setS_type	(s_type);																
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}			
				System.out.println("영업캠페인수당 등록"+feedp_size);
				
			} else {
			  //영업캠페인실적 등록
			    //일자별 max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    			    
				Vector feedps = ad_db.getStatCampSale1(today);
				int feedp_size = feedps.size();
						
				for (int i = 0  ; i < feedp_size ; i++){
					Hashtable feedp = (Hashtable)feedps.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);				
					
					bean.setSeq(i+1+m_cnt);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp.get("BUS_ID")));
					bean.setAmt1(AddUtil.parseFloat(String.valueOf(feedp.get("AMT1"))));
					bean.setS_type	(s_type);																
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}			
				System.out.println("영업캠페인실적 등록"+feedp_size);		
			}  //수당 or 실적 	
		}
	}
	
	if(mode.equals("13"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//마감 중복 확인
				
		if(flag12 == 0){
			if ( s_type.equals("1") ) {	
				// 채권캠페인수당 등록
				Vector feedps1	 = ad_db.getStatCampSettle(today);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt(AddUtil.parseInt(String.valueOf(feedp1.get("AMT"))));
					bean.setS_type	(s_type);											
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}				
				System.out.println("채권캠페인수당 등록"+feedp1_size);
			} else {
				
				  //일자별 max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// 채권캠페인실적 등록
				Vector feedps1	 = ad_db.getStatCampSettle1(today);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1+m_cnt);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt1(AddUtil.parseFloat(String.valueOf(feedp1.get("AMT1"))));
					bean.setAmt2(AddUtil.parseFloat(String.valueOf(feedp1.get("AMT2"))));
					bean.setAmt3(AddUtil.parseFloat(String.valueOf(feedp1.get("AMT3"))));
					bean.setS_type	(s_type);											
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}				
				System.out.println("채권캠페인실적 등록"+feedp1_size);			
			} //수당 or 실적 	
		}
	}
	
	if(mode.equals("25"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//마감 중복 확인 - 1군정비
		
		
		if(flag12 == 0){
			if ( s_type.equals("1") ) {		
				// 비용캠페인수당 등록
				Vector feedps1	 = ad_db.getStatCampCost(today, mode);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt(AddUtil.parseInt(String.valueOf(feedp1.get("AMT"))));
					bean.setS_type	(s_type);												
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}							
				System.out.println("비용(1군-정비)캠페인수당 등록"+feedp1_size);
			} else {
			  //일자별 max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// 비용캠페인실적 등록
				Vector feedps1	 = ad_db.getStatCampCost1(today, mode);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1+m_cnt);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt1(AddUtil.parseInt(String.valueOf(feedp1.get("AMT1"))));
					bean.setS_type	(s_type);												
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}							
				System.out.println("비용(1군-정비)캠페인실적 등록"+feedp1_size);			
			} //수당 or 실적 	
		}
	}
	
	if(mode.equals("28"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//마감 중복 확인 -1군사고
		
		
		if(flag12 == 0){
			if ( s_type.equals("1") ) {		
				// 비용캠페인수당 등록
				Vector feedps1	 = ad_db.getStatCampCost(today, mode);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt(AddUtil.parseInt(String.valueOf(feedp1.get("AMT"))));
					bean.setS_type	(s_type);												
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}							
				System.out.println("비용(1군-사고)캠페인수당 등록"+feedp1_size);
			} else {
			  //일자별 max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// 비용캠페인실적 등록
				Vector feedps1	 = ad_db.getStatCampCost1(today, mode);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1+m_cnt);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt1(AddUtil.parseInt(String.valueOf(feedp1.get("AMT1"))));
					bean.setS_type	(s_type);												
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}							
				System.out.println("비용(1군-사고)캠페인실적 등록"+feedp1_size);			
			} //수당 or 실적 	
		}
	}
	
	if(mode.equals("29"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//마감 중복 확인- 2군
		
		
		if(flag12 == 0){
			if ( s_type.equals("1") ) {		
				// 비용캠페인수당 등록
				Vector feedps1	 = ad_db.getStatCampCost(today, mode);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt(AddUtil.parseInt(String.valueOf(feedp1.get("AMT"))));
					bean.setS_type	(s_type);												
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}							
				System.out.println("비용(2군)캠페인수당 등록"+feedp1_size);
			} else {
			  //일자별 max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// 비용캠페인실적 등록
				Vector feedps1	 = ad_db.getStatCampCost1(today, mode);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1+m_cnt);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt1(AddUtil.parseInt(String.valueOf(feedp1.get("AMT1"))));
					bean.setS_type	(s_type);												
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}							
				System.out.println("비용(2군)캠페인실적 등록"+feedp1_size);			
			} //수당 or 실적 	
		}
	}
	
	if(mode.equals("30"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//마감 중복 확인- 1군
		
		
		if(flag12 == 0){
			if ( s_type.equals("1") ) {		
				// 비용캠페인수당 등록 (1군)
				Vector feedps1	 = ad_db.getStatCampCost(today, mode);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt(AddUtil.parseInt(String.valueOf(feedp1.get("AMT"))));
					bean.setS_type	(s_type);												
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}							
				System.out.println("비용(1군)캠페인수당 등록"+feedp1_size);
			} else {
			  //일자별 max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// 비용캠페인실적 등록
				Vector feedps1	 = ad_db.getStatCampCost1(today, mode);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1+m_cnt);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt1(AddUtil.parseInt(String.valueOf(feedp1.get("AMT1"))));
					bean.setS_type	(s_type);												
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}							
				System.out.println("비용(1군)캠페인실적 등록"+feedp1_size);			
			} //수당 or 실적 	
		}
	}
	
	if(mode.equals("26"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//마감 중복 확인
				
		if(flag12 == 0){
			if ( s_type.equals("1") ) {			
				// 제안캠페인수당 등록
				Vector feedps1	 = ad_db.getStatCampProp(today);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt(AddUtil.parseInt(String.valueOf(feedp1.get("AMT"))));
					bean.setS_type	(s_type);													
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}
				
				System.out.println("제안캠페인수당 등록"+feedp1_size);	
			} else {
			  //일자별 max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// 제안캠페인실적 등록
				Vector feedps1	 = ad_db.getStatCampProp1(today);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1+m_cnt);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt1(AddUtil.parseInt(String.valueOf(feedp1.get("AMT1"))));
					bean.setS_type	(s_type);													
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}
				
				System.out.println("제안캠페인실적 등록"+feedp1_size);				
			} //수당 or 실적 	
		}
	}
 
 	if(mode.equals("27"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//마감 중복 확인
				
		if(flag12 == 0){
			if ( s_type.equals("1") ) {	
				// 관리대수분기마감 등록
				Vector feedps1	 = ad_db.getStatMngSettle(s_year, s_month);
				int feedp1_size = feedps1.size();
						
				for (int i = 0 ; i < feedp1_size ; i++){
					Hashtable feedp1 = (Hashtable)feedps1.elementAt(i);
								
					StatCmpBean bean = new StatCmpBean();
					bean.setSave_dt(today);
					
					bean.setSeq(i+1);	
					bean.setC_yy	(s_year);
					bean.setC_mm	(s_month);
					bean.setGubun	(String.valueOf(feedp1.get("GUBUN")));
					bean.setUser_id	(String.valueOf(feedp1.get("BUS_ID")));
					bean.setAmt(AddUtil.parseInt(String.valueOf(feedp1.get("AMT"))));
					bean.setAmt1(AddUtil.parseInt(String.valueOf(feedp1.get("AMT1"))));
					bean.setS_type	(s_type);											
					if(!ad_db.insertStatCmp(bean)) flag12 = 1;
				}				
				System.out.println("관리대수분기마감 등록"+feedp1_size);
				
			} //수당 or 실적 	
		}
	}
	
 
%>
<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

</form>
<script language='javascript'>
<%	if(flag12 != 0){%>
	alert(' 등록 오류발생!!');	
<%	}else{		%>
		alert("처리되었습니다");
<%	}			%>
</script>
</body>
</html>