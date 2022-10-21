<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS_Auction</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 

<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body ���� �Ӽ� */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '�������';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* ���̾ƿ� ū�ڽ� �Ӽ� */
#wrap {float:left; margin:0 auto; width:100%; background-color:#322719;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* �޴������ܵ� */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu a{text-decoration:none; color:#fff;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

/* �˻�â */
#search fieldset {padding:0px 0px; border:0px;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .name {float:left; position:absolute; width:100px; margin:5px 20px 0 20px; color:#ffe4a9;}
#search .userform .userinput {padding-right:60px; height:50px; margin:0 20px 0 85px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:25px;}


/* UI Object */

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}
/* //UI Object */


#dj_list table{margin:auto;width:90%; text-align:center; border-bottom:2px solid #c18d44; border-top:1px solid #c18d44; font:11px Tahoma;}
#dj_list table th{padding:7px 0 4px 0;  border-top:1px solid #c18d44; border-left:1px solid #c18d44; border-right:1px solid #c18d44; font:13px NanumGothic; font-weight:bold; color:#e4ddd4; height:30px;}
#dj_list table td{padding:6px 0 4px 0; border-top:1px solid #c18d44;  font:13px NanumGothic; color:#e4ddd4; font-weight:bold; height:30px ; background-color:#322719;}
#dj_list table a{color:#e4ddd4; padding:8px 8px;}
#dj_list table th.n{border-right:0px;}

li.ment{font-size:0.8em; color:#545454;}
</style>


<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_actn.*"%>
<%@ include file="/smart/cookies.jsp" %>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<%	
	String s_yy 		= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");

	String iw = request.getParameter("iw")==null?"6":request.getParameter("iw"); 
	
	Vector vt = olaD.AuctionMobileList(s_yy, s_mm, iw);
	int actn_size = vt.size();
	
		
	int s_su1 = 0; //�������� ��ǰ���
	int g_su1 = 0; //�۷κ�-��ȭ ��ǰ���
	int gb_su1 = 0; //�۷κ�-�д� ��ǰ���\
	int lo_su1 = 0; //�Ե���Ż
	int kc_su1 = 0; //kcar
	
	int s_su2 = 0; //�������� �������
	int g_su2 = 0; //�۷κ�-��ȭ �������
	int gb_su2 = 0; //�۷κ�-�д� �������
	int lo_su2 = 0;
	int kc_su2 = 0;
	
	long s_su2_amt = 0; //�������� ������ �հ�
	long g_su2_amt = 0; //�۷κ�-��ȭ ������ �հ�
	long gb_su2_amt = 0; //�۷κ�-�д� ������ �հ�
	long lo_su2_amt = 0;
	long kc_su2_amt = 0;
	
	long s_su3_amt = 0; //�������� Ź�۷� - ����
	long s_su4_amt = 0; //�������� ��ǰ������ - ����
	long s_su5_amt = 0; //�������� ����ǰ������ - ����
	long s_su6_amt = 0; //�������� ���������� - ������ * 2% + �ΰ��� 10%, �ִ�ݾ� 33����
	long s_su7_amt = 0; //�������� �հ�
	long s_su8_amt = 0; //�������� �Աݿ������
	
	
	long g_su3_amt = 0; //�۷κ�-��ȭ Ź�۷� - ����:34000��, ����:86000��, �λ�:143000��
	long g_su4_amt = 0; //�۷κ�-��ȭ ��ǰ������ - 60500��
	long g_su5_amt = 0; //�۷κ�-��ȭ ����ǰ������ - 66000��
	long g_su6_amt = 0; //�۷κ�-��ȭ ���������� - ������ * 2% + �ΰ��� 10%, �ִ�ݾ� 33����
	long g_su7_amt = 0; //�۷κ�-��ȭ �հ�
	long g_su8_amt = 0; //�۷κ�-��ȭ �Աݿ������
	
	long gb_su3_amt = 0; //�۷κ�-�д� Ź�۷� - ����:34000��, ����:86000��, �λ�:143000��
	long gb_su4_amt = 0; //�۷κ�-�д� ��ǰ������ - 60500��
	long gb_su5_amt = 0; //�۷κ�-�д� ����ǰ������ - 66000��
	long gb_su6_amt = 0; //�۷κ�-�д� ���������� - ������ * 2% + �ΰ��� 10%, �ִ�ݾ� 33���� ���� �ΰ��� 1.1%�� ����.
	long gb_su7_amt = 0; //�۷κ�-�д� �հ�
	long gb_su8_amt = 0; //�۷κ�-�д� �Աݿ������
	
	long lo_su3_amt = 0; //�Ե���Ż Ź�۷� - ����
	long lo_su4_amt = 0; //�Ե���Ż ��ǰ������ - 33000
	long lo_su5_amt = 0; //�Ե���Ż ����ǰ������ - ����
	long lo_su6_amt = 0; //�Ե���Ż ���������� - ������ * 1.1%, ���Ѱ� - 16500, ���Ѱ� - 165000
	long lo_su7_amt = 0; //�Ե���Ż �հ�
	long lo_su8_amt = 0; //�Ե���Ż �Աݿ������
	
	long kc_su3_amt = 0; //kcar Ź�۷� - ����
	long kc_su4_amt = 0; //kcar ��ǰ������ - 22000
	long kc_su5_amt = 0; //kcar ����ǰ������ - 22000
	long kc_su6_amt = 0; //kcar ���������� - ������ * 1.1%, ���Ѱ� - 16500, ���Ѱ� - 165000
	long kc_su7_amt = 0; //kcar �հ�
	long kc_su8_amt = 0; //kcar �Աݿ������
	
	//���Ͱ�� 
	long t1=0;
	long t2=0;
	long t3=0;
	long t4=0;  //�Ե� 
	long t5=0;  //kcar
	
	
%> 
<!--
<link rel=stylesheet type="text/css" href="/include/table_t.css"> -->
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		fm.action = 'car_auction_list.jsp';
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}

	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "stat_main.jsp";		
		fm.submit();
	}
	
	function view_actn(actn_id, idx, s_yy, s_mm, iw){
		var fm = document.form1;
	
		var url = "?actn_id=" + actn_id
				+ "&s_yy=" + s_yy
				+ "&s_mm=" + s_mm
				+ "&iw=" + iw
				+ "&idx=" + idx;
				
		if(actn_id == '011723' || actn_id == '003226'|| actn_id == '020385'){	//��������
			var SUBWIN="car_auction_view.jsp" + url;		
		}else {
			var SUBWIN="car_auction_view2.jsp" + url;	
		}
		
		window.open(SUBWIN, 'popwin_next','scrollbars=yes,status=no,resizable=no,width=900,height=400,top=200,left=200');
	
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='car_auction_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">�����Ȳ</span></div>
            <div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='����ȭ�� ����'><img src=/smart/images/button_back.gif align=absmiddle /></a>				
				<a href='/smart/main.jsp' title='Ȩ'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
    	<div id="search">
			<!--ui object -->
			<fieldset class="srch">
				<legend>�˻�����</legend>
				<select name="s_yy" >
	          		<% for(int i=2010; i<=AddUtil.getDate2(1); i++){%>
	          		<option value="<%=i%>" <%if(i == AddUtil.parseInt(s_yy)){%> selected <%}%>><%=i%>�⵵</option>
	          		<%}%>
	        	</select>
				<select name="s_mm">
	          		<option value="" <%if(s_mm.equals("")){%> selected <%}%>>��ü</option>        
	          		<% for(int i=1; i<=12; i++){%>        
	          		<option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(s_mm)){%> selected <%}%>><%=AddUtil.addZero2(i)%>��</option>
	          		<%}%>
	        	</select> 			
				<select name="iw">
	          		
					<option value="5" <%if(iw.equals("6")){%> selected <%}%>>����</option>
					<option value="" <%if(iw.equals("")){%> selected <%}%>>��ü</option>
	          		<option value="1" <%if(iw.equals("1")){%> selected <%}%>>1����</option>
					<option value="2" <%if(iw.equals("2")){%> selected <%}%>>2����</option>
					<option value="3" <%if(iw.equals("3")){%> selected <%}%>>3����</option>
					<option value="4" <%if(iw.equals("4")){%> selected <%}%>>4����</option>
					<option value="5" <%if(iw.equals("5")){%> selected <%}%>>5����</option>
	        	</select>
				<input alt=�˻� src="/smart/images/btn_srch.gif" type="image"> 
			</fieldset> 
			<!--//ui object -->
		</div>	
  
		<br>
	
		 <% for(int i = 0 ; i < actn_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			if (ht.get("ACTN_ID").equals("011723") || ht.get("ACTN_ID").equals("003226") || ht.get("ACTN_ID").equals("020385")) {//��������
				s_su1 += 1; //��ǰ��Ȳ
				if(ht.get("ACTN_ST").equals("4")){ 
					s_su2 += 1; //������Ȳ
					s_su2_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR"))); //������ �հ�
					
					s_su6_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM1_TOT"))); //����������
					//if(AddUtil.parseLong(String.valueOf(ht.get("NAK_PR"))) * 0.022 > 440000 ){
					//	s_su6_amt  += 440000; //���������� �ִ� 33����
					//}else{
					//	s_su6_amt += Math.ceil(AddUtil.parseLong(String.valueOf(ht.get("NAK_PR"))) * 0.022); //���������� = ������ * 2.2%(0.022)
					//}
					//System.out.println("s_su6_amt"+Math.ceil(s_su6_amt));				
					//System.out.println("String.valueOf()="+Math.ceil(AddUtil.parseLong(String.valueOf(ht.get("NAK_PR"))) * 0.022));
					//���Ͱ��			
					 t1 +=  ( AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT"))) - ( AddUtil.parseLong(String.valueOf(ht.get("GET_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR"))) - AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER"))) - AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT"))) ) ) ; 
				 }	
				 s_su7_amt = s_su3_amt+s_su4_amt+s_su5_amt+s_su6_amt; //��� �հ�
				 s_su8_amt = s_su2_amt - s_su7_amt; //�Աݿ������
							
				
			}else if(ht.get("ACTN_ID").equals("000502")){//�۷κ�-��ȭ
				g_su1 += 1;
				
				if(ht.get("ACTN_ST").equals("4")){ 
					g_su2 += 1; 
					g_su2_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")));
					
					if(AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")))  > 15000000 ){
					//	g_su6_amt  += 15000000*0.011;
					}else{
					//	g_su6_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR"))) * 0.011;
					}
					
					g_su6_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM1_TOT")));
					
					//���Ͱ��			
					t2 +=  ( AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT"))) - ( AddUtil.parseLong(String.valueOf(ht.get("GET_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR"))) - AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER"))) - AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT"))) ) ) ; 
				}	
				
				g_su3_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM3_TOT"))); //Ź�۷�
				
				if(AddUtil.parseInt(String.valueOf(ht.get("ACTN_DT"))) >= 20121201){
					if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 30000){
						g_su4_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); // ��ǰ������
					}else{
						g_su5_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); //����ǰ������
					}
				}else{
					if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 60500){
						g_su4_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); // ��ǰ������
					}else{
						g_su5_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); //����ǰ������
					}
				}
					
				g_su7_amt = g_su3_amt+g_su4_amt+g_su5_amt+g_su6_amt;
				g_su8_amt = g_su2_amt - g_su7_amt;
				
				
			}else if(ht.get("ACTN_ID").equals("013011")){//�۷κ�-�д�
				gb_su1 += 1;
				
				if(ht.get("ACTN_ST").equals("4")){ 
					gb_su2 += 1; 
					gb_su2_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")));
					
					if(AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")))  > 15000000 ){
					//	gb_su6_amt  += 15000000*0.011;
					}else{
					//	gb_su6_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR"))) * 0.011;
					}
					
					gb_su6_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM1_TOT")));
					
					//���Ͱ��			
					t3 +=  ( AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT"))) - ( AddUtil.parseLong(String.valueOf(ht.get("GET_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR"))) - AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER"))) - AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT"))) )  ); 
				}
				
				gb_su3_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM3_TOT"))); //Ź�۷�
				
				if(AddUtil.parseInt(String.valueOf(ht.get("ACTN_DT"))) >= 20121201){
					if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 30000){
						gb_su4_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); // ��ǰ������
					}else{
						gb_su5_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); //����ǰ������
					}
				}else{
					if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 60500){
						gb_su4_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); // ��ǰ������
					}else{
						gb_su5_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); //����ǰ������
					}
				}
				gb_su7_amt = gb_su3_amt+gb_su4_amt+gb_su5_amt+gb_su6_amt;
				gb_su8_amt = gb_su2_amt - gb_su7_amt;
								
			}else if(ht.get("ACTN_ID").equals("022846")){//�Ե���Ż(��)
				lo_su1 += 1;
				
				if(ht.get("ACTN_ST").equals("4")){ 
					lo_su2 += 1; 
					lo_su2_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")));
					
					if(AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")))  > 15000000 ){
					//	lo_su6_amt  += 15000000*0.011;
					}else{
					//	lo_su6_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR"))) * 0.011;
					}
				
					lo_su6_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM1_TOT")));
				
						//���Ͱ��			
					t4 +=  ( AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT"))) - ( AddUtil.parseLong(String.valueOf(ht.get("GET_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR"))) - AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER"))) - AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT"))) )  ); 
						
				}	
				
				lo_su3_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM3_TOT"))); //Ź�۷�
										
				if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 33000 ){
					lo_su4_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); // ��ǰ������
				}else{
					lo_su5_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); //����ǰ������
				}
				
				lo_su7_amt = lo_su3_amt+lo_su4_amt+lo_su5_amt+lo_su6_amt;
				lo_su8_amt = lo_su2_amt - lo_su7_amt;
			
			}else if(ht.get("ACTN_ID").equals("048691")){//kcar�����
				kc_su1 += 1;
				
				if(ht.get("ACTN_ST").equals("4")){ 
					kc_su2 += 1; 
					kc_su2_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")));
					
					if(AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")))  > 15000000 ){
					//	lo_su6_amt  += 15000000*0.011;
					}else{
					//	lo_su6_amt += AddUtil.parseLong(String.valueOf(ht.get("NAK_PR"))) * 0.011;
					}
				
					kc_su6_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM1_TOT")));
					
					//���Ͱ��			
					t5 +=  ( AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT"))) - ( AddUtil.parseLong(String.valueOf(ht.get("GET_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR"))) - AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER"))) - AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT"))) - AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT"))) ) ) ; 
				}	
				
				kc_su3_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM3_TOT"))); //Ź�۷�
									
				if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 22000 ){
					kc_su4_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); // ��ǰ������
				}else{
					kc_su5_amt += AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))); //����ǰ������
				}
				
				kc_su7_amt = kc_su3_amt+kc_su4_amt+kc_su5_amt+kc_su6_amt;
				kc_su8_amt = kc_su2_amt - kc_su7_amt;			
				
			}
						
			
			%>
		 <%}%>
		 
		<div id="dj_list">	
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<th  rowspan="3" colspan="2" width="25%"><font color="#c28835">����</font></th>
						<th  width="25%"><font color="#f09310">�Ե�(��)</font></th>
						<th  width="25%"><font color="#f09310">Kcar(��)</font></th>
						<th  rowspan="3" width="25%"><font color="#f09310">�հ�</font></th>
					</tr>
					<tr>
						<th><font color="#f09310">�д�(ȭ)</font></th>
						<th><font color="#f09310">��ȭ(��)</font></th>
					</tr>
					<tr>
						<th><font color="#f09310">AJ(��)</font></th>
						<th><font color="#f09310"></font></th>
					</tr>
				
					<tr>
						<th  rowspan="6"><font color="#f09310">����</font></th>
						<th  rowspan="3"><font color="#f09310">���</font></th>
						<th ><a href="javascript:view_actn('022846','3','<%=s_yy%>','<%=s_mm%>','<%=iw%>')" onMouseOver="window.status=''; return true"><%=lo_su2%></a></th>
						<th ><a href="javascript:view_actn('048691','3','<%=s_yy%>','<%=s_mm%>','<%=iw%>')" onMouseOver="window.status=''; return true"><%=kc_su2%></a></th>
						<th rowspan="3"><%=s_su2+g_su2+gb_su2+lo_su2+kc_su2%></th>
					</tr>
					<tr>
						<th ><a href="javascript:view_actn('013011','3','<%=s_yy%>','<%=s_mm%>','<%=iw%>')" onMouseOver="window.status=''; return true"><%=gb_su2%></a></th>
						<th ><a href="javascript:view_actn('000502','3','<%=s_yy%>','<%=s_mm%>','<%=iw%>')" onMouseOver="window.status=''; return true"><%=g_su2%></a></th>
					</tr>
					<tr>
						<th ><a href="javascript:view_actn('020385','3','<%=s_yy%>','<%=s_mm%>','<%=iw%>')" onMouseOver="window.status=''; return true"><%=s_su2%></a></th>
						<th >&nbsp;</th>
					</tr>
					<tr>
						<th  rowspan="3"><font color="#f09310">��������</font></th>
						<th ><%=AddUtil.parseDecimalLong(lo_su2_amt)%></th>
						<th ><%=AddUtil.parseDecimalLong(kc_su2_amt)%></th>
						<th rowspan="3"><%=AddUtil.parseDecimalLong(s_su2_amt+g_su2_amt+gb_su2_amt+lo_su2_amt+kc_su2_amt)%></th>
					</tr>
					<tr>
						<th ><%=AddUtil.parseDecimalLong(gb_su2_amt)%></th>
						<th ><%=AddUtil.parseDecimalLong(g_su2_amt)%></th>
					</tr>
					<tr>
						<th ><%=AddUtil.parseDecimalLong(s_su2_amt)%></th>
						<th >&nbsp;</th>
					</tr>
					<tr>
						<th  rowspan="15"><font color="#f09310">���</font></th>
						<th  rowspan="3"><font color="#f09310">Ź�۷�</font></th>
						<th >����</th>
						<th >����</th>
						<th rowspan="3"><%=AddUtil.parseDecimalLong(s_su3_amt+g_su3_amt+gb_su3_amt)%></th>
					</tr>
					<tr>
						<th ><%=AddUtil.parseDecimalLong(gb_su3_amt)%></th>
						<th ><%=AddUtil.parseDecimalLong(g_su3_amt)%></th>
					</tr>
					<tr>
						<th >����</th>
						<th >&nbsp;</th>
					</tr>
					<tr>
						<th  rowspan="3"><font color="#f09310">��ǰ<br>������</font></th>
						<th ><%=AddUtil.parseDecimalLong(lo_su4_amt)%></th>
						<th ><%=AddUtil.parseDecimalLong(kc_su4_amt)%></th>
						<th rowspan="3"><%=AddUtil.parseDecimalLong(s_su4_amt+g_su4_amt+gb_su4_amt+lo_su4_amt+kc_su4_amt)%></th>
					</tr>
					<tr>
						<th ><%=AddUtil.parseDecimalLong(gb_su4_amt)%></th>
						<th ><%=AddUtil.parseDecimalLong(g_su4_amt)%></th>
					</tr>
					<tr>
						<th >����</th>
						<th >&nbsp;</th>
					</tr>
					<tr>
						<th  rowspan="3"><font color="#f09310">����ǰ<br>������</font></th>
						<th><%=AddUtil.parseDecimalLong(lo_su5_amt)%></th>
						<th><%=AddUtil.parseDecimalLong(kc_su5_amt)%></th>
						<th rowspan="3"><%=AddUtil.parseDecimalLong(s_su5_amt+g_su5_amt+gb_su5_amt+lo_su5_amt+kc_su5_amt)%></th>
					</tr>
					<tr>
						<th><%=AddUtil.parseDecimalLong(gb_su5_amt)%></th>
						<th><%=AddUtil.parseDecimalLong(g_su5_amt)%></th>
					</tr>
					<tr>
						<th>����</th>
						<th>&nbsp;</th>
					</tr>
					<tr>
						<th  rowspan="3"><font color="#f09310">����<br>������</font></th>
						<th><%=AddUtil.parseDecimalLong(lo_su6_amt)%></th>
						<th><%=AddUtil.parseDecimalLong(kc_su6_amt)%></th>
						<th rowspan="3"><%=AddUtil.parseDecimalLong(s_su6_amt+g_su6_amt+gb_su6_amt+lo_su6_amt+kc_su6_amt)%></th>
					</tr>
					<tr>
						<th><%=AddUtil.parseDecimalLong(gb_su6_amt)%></th>
						<th><%=AddUtil.parseDecimalLong(g_su6_amt)%></th>
					</tr>
					<tr>
						<th><%=AddUtil.parseDecimalLong(s_su6_amt)%></th>
						<th>&nbsp;</th>
					</tr>
					<tr>
						<th rowspan="3"><font color="#f09310">����</font></th>
						<th><%=AddUtil.parseDecimalLong(lo_su7_amt)%></th>
						<th><%=AddUtil.parseDecimalLong(kc_su7_amt)%></th>
						<th rowspan="3"><%=AddUtil.parseDecimalLong(s_su7_amt+g_su7_amt+gb_su7_amt+lo_su7_amt+kc_su7_amt)%></th>
					</tr>
					<tr>
						<th><%=AddUtil.parseDecimalLong(gb_su7_amt)%></th>
						<th><%=AddUtil.parseDecimalLong(g_su7_amt)%></th>
					</tr>
					<tr>
						<th><%=AddUtil.parseDecimalLong(s_su7_amt)%></th>
						<th>&nbsp;</th>
					</tr>
					<tr>
						<th rowspan="3" colspan="2"><font color="#f09310">�Աݿ����ݾ�</font></th>
						<th><%=AddUtil.parseDecimalLong(lo_su8_amt)%></th>
						<th><%=AddUtil.parseDecimalLong(kc_su8_amt)%></th>
						<th rowspan="3"><%=AddUtil.parseDecimalLong(s_su8_amt+g_su8_amt+gb_su8_amt+lo_su8_amt+kc_su8_amt)%></th>
					</tr>
					<tr>
						<th><%=AddUtil.parseDecimalLong(gb_su8_amt)%></th>
						<th><%=AddUtil.parseDecimalLong(g_su8_amt)%></th>
					</tr>
					<tr>
						<th><%=AddUtil.parseDecimalLong(s_su8_amt)%></th>
						<th>&nbsp;</th>
					</tr>
			</table>
		</div>
		<p><br></p>
		<div id="dj_list">
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<th rowspan="3" width="25%"><font color="#f09310">����</font></th>
						<th width="25%"><font color="#d3f010"><%=Util.parseDecimal(t4)%>&nbsp;</font></th>
						<th width="25%"><font color="#d3f010"><%=Util.parseDecimal(t5)%>&nbsp;</font></th>
						<th rowspan="3" width="25%"><font color="#d3f010"><%=Util.parseDecimal(t1 + t2 + t3 + t4 + t5)%>&nbsp;</font></th>
					</tr>
					<tr>
						<th><font color="#d3f010"><%=Util.parseDecimal(t3)%>&nbsp;</font></th>
						<th><font color="#d3f010"><%=Util.parseDecimal(t2)%>&nbsp;</font></th>
					</tr>
					<tr>
						<th><font color="#d3f010"><%=Util.parseDecimal(t1)%>&nbsp;</font></th>
						<th><font color="#d3f010">&nbsp;</font></th>
					</tr>
			</table>
		</div>
	</div> 
	<div id="footer"></div>     
</div>
</form>
</body>
</html>