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
	String s_type 	= request.getParameter("s_type")==null? "":request.getParameter("s_type"); //1:���޾� �Ǵ� 2:����
		
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
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type );//���� �ߺ� Ȯ��		
		
		if(flag12 == 0){
		
			if ( s_type.equals("1") ) {
			  //����ķ���μ��� ���
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
				System.out.println("����ķ���μ��� ���"+feedp_size);
				
			} else {
			  //����ķ���ν��� ���
			    //���ں� max 
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
				System.out.println("����ķ���ν��� ���"+feedp_size);		
			}  //���� or ���� 	
		}
	}
	
	if(mode.equals("13"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//���� �ߺ� Ȯ��
				
		if(flag12 == 0){
			if ( s_type.equals("1") ) {	
				// ä��ķ���μ��� ���
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
				System.out.println("ä��ķ���μ��� ���"+feedp1_size);
			} else {
				
				  //���ں� max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// ä��ķ���ν��� ���
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
				System.out.println("ä��ķ���ν��� ���"+feedp1_size);			
			} //���� or ���� 	
		}
	}
	
	if(mode.equals("25"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//���� �ߺ� Ȯ�� - 1������
		
		
		if(flag12 == 0){
			if ( s_type.equals("1") ) {		
				// ���ķ���μ��� ���
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
				System.out.println("���(1��-����)ķ���μ��� ���"+feedp1_size);
			} else {
			  //���ں� max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// ���ķ���ν��� ���
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
				System.out.println("���(1��-����)ķ���ν��� ���"+feedp1_size);			
			} //���� or ���� 	
		}
	}
	
	if(mode.equals("28"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//���� �ߺ� Ȯ�� -1�����
		
		
		if(flag12 == 0){
			if ( s_type.equals("1") ) {		
				// ���ķ���μ��� ���
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
				System.out.println("���(1��-���)ķ���μ��� ���"+feedp1_size);
			} else {
			  //���ں� max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// ���ķ���ν��� ���
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
				System.out.println("���(1��-���)ķ���ν��� ���"+feedp1_size);			
			} //���� or ���� 	
		}
	}
	
	if(mode.equals("29"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//���� �ߺ� Ȯ��- 2��
		
		
		if(flag12 == 0){
			if ( s_type.equals("1") ) {		
				// ���ķ���μ��� ���
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
				System.out.println("���(2��)ķ���μ��� ���"+feedp1_size);
			} else {
			  //���ں� max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// ���ķ���ν��� ���
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
				System.out.println("���(2��)ķ���ν��� ���"+feedp1_size);			
			} //���� or ���� 	
		}
	}
	
	if(mode.equals("30"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//���� �ߺ� Ȯ��- 1��
		
		
		if(flag12 == 0){
			if ( s_type.equals("1") ) {		
				// ���ķ���μ��� ��� (1��)
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
				System.out.println("���(1��)ķ���μ��� ���"+feedp1_size);
			} else {
			  //���ں� max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// ���ķ���ν��� ���
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
				System.out.println("���(1��)ķ���ν��� ���"+feedp1_size);			
			} //���� or ���� 	
		}
	}
	
	if(mode.equals("26"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//���� �ߺ� Ȯ��
				
		if(flag12 == 0){
			if ( s_type.equals("1") ) {			
				// ����ķ���μ��� ���
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
				
				System.out.println("����ķ���μ��� ���"+feedp1_size);	
			} else {
			  //���ں� max 
			    int m_cnt = ad_db.getMaxSeq("stat_cmp", today, mode);
			    
				// ����ķ���ν��� ���
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
				
				System.out.println("����ķ���ν��� ���"+feedp1_size);				
			} //���� or ���� 	
		}
	}
 
 	if(mode.equals("27"))
	{
		flag12 = ad_db.getInsertYn("stat_cmp", today, mode, s_type);//���� �ߺ� Ȯ��
				
		if(flag12 == 0){
			if ( s_type.equals("1") ) {	
				// ��������б⸶�� ���
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
				System.out.println("��������б⸶�� ���"+feedp1_size);
				
			} //���� or ���� 	
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
	alert(' ��� �����߻�!!');	
<%	}else{		%>
		alert("ó���Ǿ����ϴ�");
<%	}			%>
</script>
</body>
</html>