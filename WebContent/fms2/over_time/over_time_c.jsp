<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.over_time.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>
<%

	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	OverTimeDatabase otd = OverTimeDatabase.getInstance();
	
	String us_id = request.getParameter("us_id")==null?"":request.getParameter("us_id");

	String id = "";			
	String user_h_tel ="";
	String user_m_tel ="";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";
	String user_nm = "";
	String br_id = "";
	String auth_rw = "";
	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String reg_dt = "";
	
	String over_sjgj = "";
	String over_sjgj_dt = "";
	String over_sjgj_op = "";
	String over_cont = "";
	String over_cr = "";
	String st_time = "";
	String st_year = "";
	String st_mon = "";
	String st_day = "";
	String ed_time = "";
	String ed_year = "";
	String ed_mon = "";
	String ed_day = "";
	
	/* �����ٷνð�/�����ٷνð� */
	String jb_time = "";
	String jb_time2 = "";
	
	String over_addr = "";
	
	String over_card1_dt ="";
	int over_card1_amt =0;
	String over_cash1_dt ="";
	int over_cash1_amt =0;
	String over_cash1_file ="";
	int over_cash1_cr_amt =0;
	String over_cash1_cr_dt = "";
	String over_cash1_cr_jpno = "";
	String over_s_cash1_dt = "";
	int over_s_cash1_amt = 0;
	String over_s_cash1_file = "";
	int over_s_cash1_cr_amt =0;
	String over_s_cash1_cr_jpno ="";
	
	String over_card2_dt ="";
	int over_card2_amt =0;
	String over_cash2_dt ="";
	int over_cash2_amt =0;
	String over_cash2_file ="";
	int over_cash2_cr_amt =0;
	String over_cash2_cr_dt = "";
	String over_cash2_cr_jpno = "";
	String over_s_cash2_dt = "";
	int over_s_cash2_amt = 0;
	String over_s_cash2_file = "";
	int over_s_cash2_cr_amt = 0;
	String over_s_cash2_cr_jpno ="";
	
	String over_card3_dt ="";
	int over_card3_amt =0;
	String over_cash3_dt ="";
	int over_cash3_amt =0;
	String over_cash3_file ="";
	int over_cash3_cr_amt =0;
	String over_cash3_cr_dt = "";
	String over_cash3_cr_jpno = "";
	String over_s_cash3_dt = "";
	int over_s_cash3_amt = 0;
	String over_s_cash3_file = "";
	int over_s_cash3_cr_amt =0;
	String over_s_cash3_cr_jpno ="";
	
	int over_card_tot =0;
	int over_cash_tot =0;
	int over_s_cash_tot =0;
	
	int over_scgy = 0;
	String over_scgy_dt ="";
	String over_scgy_pl_dt ="";
	
	String s_check ="";
	String s_check_dt ="";
	String s_check_id = "";

	String s_check1 ="";
	String s_check1_dt ="";
	String s_check1_id = "";
	
	String t_check = "";
	String t_check_dt = "";
	String t_check_id = "";
	
	String t_check1 = "";
	String t_check1_dt = "";
	String t_check1_id = "";
	
	String t_check2 = "";
	String t_check2_dt = "";
	String t_check2_id = "";
	
	String t_check3 = "";
	String t_check3_dt = "";
	String t_check3_id = "";
	
	String over_time_mon ="";

	
	int count = 0;
	
	Vector vt = otd.Over_Per(user_id, doc_no);
	int vt_size = vt.size();
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

	
	reg_dt = Util.getDate();
	us_id =  ck_acar_id;
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_nm = u_bean.getBr_nm();
	dept_nm = u_bean.getDept_nm();
	
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleOt("8", doc_no);	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

	int size = 0;
	
	String content_code = "OVER_TIME";
	String content_seq  = doc_no;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_type2 = "";
	String seq2 = "";
	String file_type3 = "";
	String seq3 = "";
	String file_type4 = "";
	String seq4 = "";
	String file_type5 = "";
	String seq5 = "";
	String file_type6 = "";
	String seq6 = "";
	
	
	
	
	for(int i=0; i< attach_vt.size(); i++){
    	Hashtable ht = (Hashtable)attach_vt.elementAt(i);   
		
		if((doc_no+1).equals(ht.get("CONTENT_SEQ"))){
			over_cash1_file = String.valueOf(ht.get("FILE_NAME"));
			file_type1 = String.valueOf(ht.get("FILE_TYPE"));
			seq1 = String.valueOf(ht.get("SEQ"));
			
		}else if((doc_no+2).equals(ht.get("CONTENT_SEQ"))){
			over_s_cash1_file = String.valueOf(ht.get("FILE_NAME"));
			file_type2 = String.valueOf(ht.get("FILE_TYPE"));
			seq2 = String.valueOf(ht.get("SEQ"));
			
		}else if((doc_no+3).equals(ht.get("CONTENT_SEQ"))){
			over_cash2_file = String.valueOf(ht.get("FILE_NAME"));
			file_type3 = String.valueOf(ht.get("FILE_TYPE"));
			seq3 = String.valueOf(ht.get("SEQ"));
			
		}else if((doc_no+4).equals(ht.get("CONTENT_SEQ"))){
			over_s_cash2_file = String.valueOf(ht.get("FILE_NAME"));
			file_type4 = String.valueOf(ht.get("FILE_TYPE"));
			seq4 = String.valueOf(ht.get("SEQ"));
			
		}else if((doc_no+5).equals(ht.get("CONTENT_SEQ"))){
			over_cash3_file = String.valueOf(ht.get("FILE_NAME"));
			file_type5 = String.valueOf(ht.get("FILE_TYPE"));
			seq5 = String.valueOf(ht.get("SEQ"));
			
		}else if((doc_no+6).equals(ht.get("CONTENT_SEQ"))){
			over_s_cash3_file = String.valueOf(ht.get("FILE_NAME"));
			file_type6 = String.valueOf(ht.get("FILE_TYPE"));
			seq6 = String.valueOf(ht.get("SEQ"));
			
		}
	}		
%>

<html>
<head>
<title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
		var popObj = null;
		
		
function time_ok()
{
	var theForm = document.form1;
	
	theForm.cmd.value="ok";
	theForm.t_check.value="Y";
	theForm.doc_bit.value = "7";
	theForm.doc_step.value = "3";
	
		if(confirm('�λ����ڴ� �����Ͻðڽ��ϱ�?')){
			theForm.action='over_time_sk.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';		
			theForm.target="i_no";
			theForm.submit();
		}
}


function s_check()
{
	var theForm = document.form1;
	
	theForm.cmd.value="sk";
	theForm.s_check.value="Y";
	theForm.doc_bit.value = "2";
	theForm.doc_step.value = "2";
		
		if(confirm('�������� �����Ͻðڽ��ϱ�?')){	
			theForm.action='over_time_sk.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';		
			theForm.target='i_no';
			theForm.submit();
		}						
}


function Over_time_close()
{
	
	self.close();
	window.close();
}

function Over_time_del()
{
	var theForm = document.form1;
	theForm.cmd.value = "d";
		
	if(confirm('�����Ͻðڽ��ϱ�?')){	
			theForm.action='over_time_sk.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';		
			theForm.target='i_no';
			theForm.submit();
		}
}

//�˾������� ����
	function MM_openBrWindow2(theURL,winName,features) { //v2.0
//		theURL = "http://fms1.amazoncar.co.kr/data/over_time/"+theURL;   //����
		theURL = "https://fms3.amazoncar.co.kr/data/over_time/"+theURL;				//�׽�Ʈ ��
		window.open(theURL,winName,features);
		
//		file_down_history();
	}
	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr/data/over_time/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
		//file_down_history();	
	}
	
//����Ʈ ����	
function go_to_list()
{
		var fm = document.form1;
		location = "over_time_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";
	
}	

//�����ٷνð� ����
function jb_time_modify()
{
	var theForm = document.form1;
	theForm.cmd.value = "mo";
		
	if(confirm('�����ð��� ���� �Ͻðڽ��ϱ�?')){	
			theForm.action='over_time_sk.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';		
			theForm.target='i_no';
			theForm.submit();
		}
	}

//�ͼӿ� ����
function over_time_mon_modify()
{
	var theForm = document.form1;
	theForm.cmd.value = "otm";
	
	var ch_mon= theForm.over_time_mon.value; 
	//�ͼӿ��� ���ڸ� 
	if ( ch_mon.length != 2 ) {
		alert("�ͼӿ��� Ȯ���ϼ���!!\n ex)01, 02, ..., 11, 12 ");
		return;
	}
		
	if(confirm('�ͼӿ��� ���� �Ͻðڽ��ϱ�?')){	
			theForm.action='over_time_sk.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';		
			theForm.target='i_no';
			theForm.submit();
		}
	}

	//��ĵ���
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=ck_acar_id%>&br_id=<%=br_id%>&doc_no=<%=doc_no%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	
//-->
</script>
<script language='javascript'>
<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=10;	

		print();
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body>

<form action="" name="form1" method="post" >
<input type="hidden" name="user_id" value="<%=user_id%>">	
<input type="hidden" name="us_id" value="<%=us_id%>">	

<input type="hidden" name="s_check" value="">
<input type="hidden" name="s_check1" value="">
<input type="hidden" name="t_check" value="">
<input type="hidden" name="t_check1" value="">
<input type="hidden" name="t_check2" value="">
<input type="hidden" name="t_check3" value="">
<input type='hidden' name="doc_bit" value="">          
<input type='hidden' name="doc_step" value="">
          
<input type='hidden' name="doc_no" value="<%=doc_no%>">    
<input type="hidden" name="cmd" value="">	
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   	

<table border="0" cellspacing="0" cellpadding="0" width="100%">
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>  	

	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7
						height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img
						src=/acar/images/center/menu_bar_dot.gif width=4 height=5
						align=absmiddle border=0>&nbsp;<span class=style1>�λ���� > ���°��� > <span class=style5><%=ht.get("USER_NM")%>-Ư�ټ��� ��û�� Ȯ��</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7
						height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td colspan='4' align='right'>
		<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align=absmiddle border=0></a></td>
	</tr>
<!-- ���翩�� ���� -->
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="12.5%" rowspan="2" class="title">����<br>(<%=ht.get("DEPT_NM")%>)</td>
					<td width="12.5%" align="center" class="title">�����</td>
					<td width="12.5%" align="center" class="title">������/����</td>
					<td width="12.5%" align="center" class="title"></td>
					<td width="12.5%" align="center" class="title"></td>
					<td width="12.5%" align="center" class="title"></td>
					<td width="12.5%" align="center" class="title"></td>
					<td width="12.5%" align="center" class="title">��ǥ�̻�</td>					
				</tr>
				<tr>
				  <td width="12.5%" height="50" align="center"><%=ht.get("USER_NM")%></td>				  
				  <td width="12.5%" height="50" align="center"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>				  
				    <%if(doc.getUser_dt2().equals("") ){
        			  		String user_id2 = doc.getUser_id2();
        		 	             %>
	        			  <%	if(user_id2.equals(us_id) || nm_db.getWorkAuthUser("������",user_id) ){%>
	        			   <a href='javascript:s_check()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align=absmiddle border=0></a>
	        			  <%	}%>
	        			    <br>&nbsp;
	        			  <%}%>
	        			  </td>        	
			
			      <td width="12.5%" height="50" align="center">&nbsp;</td>
			      <td width="12.5%" height="50" align="center">&nbsp;</td>
			      <td width="12.5%" height="50" align="center">&nbsp;</td>
			      <td width="12.5%" height="50" align="center">&nbsp;</td>
			      <td width="12.5%" height="50" align="center">&nbsp;</td>
<!--			      <td width="12.5%" height="50" align="center">&nbsp;��ǥ�̻�<br>������<br><%if(ht.get("S_CHECK1").equals("")){%><%if(ht.get("S_CHECK").equals("Y")){%><a href='javascript:s_check1()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align=absmiddle border=0></a><%}}else{%><%=ht.get("S_CHECK1_DT")%><%}%></td> -->
			  </tr>
			</table>
		</td>
	</tr>	
<!-- ���翩�� �� -->
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width="12.5%">�ٹ�����/����</td>
					<td width="12.5%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DT")))%></td>
					<td class="title" width="12.5%">�ۼ�����</td>
					<td width="12.5%" align="center"><%=ht.get("REG_DT")%></td>
					<td class="title" width="12.5%">��������</td>
					<td width="12.5%" align="center"><%=ht.get("REG_DT")%></td>
					<td width="12.5%" colspan="2" class="title">�ͼӳ��(�޿�)</td>
					<td width="12.5%" align="center"><input type="text" name="over_time_year" size="4" value="<%=ht.get("OVER_TIME_YEAR")%>" >��<input type="text" name="over_time_mon" size="2" value="<%=ht.get("OVER_TIME_MON")%>" >��
					&nbsp;&nbsp;<a href='javascript:over_time_mon_modify()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_modify.gif" align=absmiddle border=0></a>	
						</td>
				</tr>
				
				<tr>
					<td width="12.5%" rowspan="2" class="title">�ҼӺμ���</td>
					<td width="12.5%" rowspan="2" align="center"><%=ht.get("DEPT_NM")%></td>
					<td width="12.5%" rowspan="2" class="title">�����ȣ</td>
					<td width="12.5%" rowspan="2" align="center"><%=ht.get("ID")%></td>
					<td width="12.5%" rowspan="2" class="title">����</td>
					<td width="12.5%" rowspan="2" align="center"><%=user_nm%></td>
					<td width="62" rowspan="2" class="title">����ó</td>
					<td class="title" width="63">�޴���</td>
					<td width="12.5%" align="center"><%=ht.get("USER_M_TEL")%></td>
				</tr>
				<tr>
				  <td class="title" width="63">�繫��</td>
			      <td width="12.5%" align="center"><%=ht.get("USER_H_TEL")%></td>
			  </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����(�޹���)�ٷ� ����</span></td>
	</tr>
    <tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width="12.5%">��������</td>
					<td width="12.5%" align="center">
						<%=ht.get("OVER_SJGJ")%>
  					</td>
					<td class="title" width="12.5%">�����������</td>
					<td width="13.5%" align="center"><%=ht.get("OVER_SJGJ_DT")%></td>
					<td class="title" width="12.5%">�̰������</td>
				<td width="475" colspan="3" align="center">&nbsp;<%=ht.get("OVER_SJGJ_OP")%>
					</td>
				</tr>
				<tr>
					<td class="title" width="12.5%">���</td>
					<td width="475" colspan="3" align="center">&nbsp;<%=AddUtil.getDate3(String.valueOf(ht.get("START_DT")))%> &nbsp; <%=ht.get("START_H")%>:<%=ht.get("START_M")%></td>
					<td class="title" width="400" colspan="4" align="left"> �ٷθ����� �̵��ð��� �����ϰ� �ٷ����忡 ������ �ð�</td>
				</tr>
				<tr>
					<td class="title" width="12.5%">���</td>
					<td width="475" colspan="3" align="center">&nbsp;<%=AddUtil.getDate3(String.valueOf(ht.get("END_DT")))%> &nbsp; <%=ht.get("END_H")%>:<%=ht.get("END_M")%></td>
					<td class="title" width="400" colspan="4"> �ٷ������� ��Ż�� �ð�</td>
				</tr>
				<tr>
					<td class="title" width="12.5%">�����ٷνð�</td>
					<%-- <td width="12.5%" align="center">&nbsp;<%=ht.get("HH")%>�ð� <%=ht.get("MI")%>��</td> --%>
					<td width="12.5%" align="center">&nbsp;<%if(Integer.parseInt(AddUtil.toString(ht.get("HH"))) < 8){%> <%=ht.get("HH")%>�ð� <%=ht.get("MI")%>�� <%}else{%>8�ð� 0��<%}%></td>
					<td class="title" width="12.5%">�����ٷνð�</td>
					<%-- <td width="13.5%" align="center">&nbsp;<input type="text" name="jb_time" size="4" value="<%if(Integer.parseInt(AddUtil.toString(ht.get("JB_TIME"))) < 2){%> 2 <%}else{%><%=ht.get("JB_TIME")%><%}%>" >�ð� --%>
					<td width="13.5%" align="center">&nbsp;<input type="text" name="jb_time" size="4" value="<%if (Integer.parseInt(AddUtil.toString(ht.get("JB_TIME"))) < 2) {%><%if (user_id.equals("000297") || user_id.equals("000313")) {%>1<%} else {%>2<%}%><%} else {%><%=ht.get("JB_TIME")%><%}%>" >�ð�
<%	if(nm_db.getWorkAuthUser("�ӿ�",us_id) || nm_db.getWorkAuthUser("������",us_id)){%>
				&nbsp;&nbsp;<a href='javascript:jb_time_modify()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_modify.gif" align=absmiddle border=0>
<%}%>					
					</td>
					<td class="title" width="400" colspan="4"> <font size="1">�繫�ǿ� ����ٷδ� �ٷ��� �ð��� 2�ð��� ��ġġ ���Ѱ�� �����ٷνð��� 2�ð����� ��</font></td>
				</tr>
<input type="hidden" name="jb_time" value="<%=jb_time%>">				
				<tr>
					<td class="title" width="12.5%">�ٷ������/�ּ�</td>
					<td width="875" colspan="7">&nbsp;<%=ht.get("OVER_ADDR")%></td>
				</tr>
				<tr>
					<td class="title" width="12.5%">�ٷλ���</td>
					<td width="875" colspan="7">&nbsp;<textarea name="over_cont" cols='140' rows='5' value='' readonly><%=ht.get("OVER_CONT")%></textarea></td>
				</tr>
				<tr>
					<td class="title" width="12.5%">�ٷΰ��</td>
					<td width="875" colspan="7">&nbsp;<textarea name="over_cr" cols='140' rows='5' value='' readonly><%=ht.get("OVER_CR")%></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����(�޹���)�ٷ��� ������� ����</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>	  
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width="65" rowspan="2">����</td>
					<td width="165" colspan="2" rowspan="2" class="title">���ⱸ��</td>
					<td class="title" width="100" rowspan="2">��������/<br>ī���������</td>
					<td class="title" width="100" rowspan="2">����ݾ�</td>
					<td class="title" width="270" rowspan="2"><p>����÷��<br>(��������)</p></td>
					<td class="title" width="300" colspan="3">���ݺ��û��/ó��</td>
				</tr>
				<tr>
					<td class="title" width="100">�ݾ�</td>
					<td class="title" width="100">��������</td>
					<td class="title" width="100">��ǥ��ȣ</td>
				</tr>
				<tr>
					<td rowspan="3" class="title" width="65">�Ĵ�</td>
					<td colspan="2" class="title" width="165">����ī��</td>
					<td width="100" align="center"><%=ht.get("OVER_CARD1_DT")%></td>
					<td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CARD1_AMT"))%></td>
					<td colspan="4" class="title" width="600"></td>
				</tr>
				<tr>
				  <td rowspan="2" class="title" width="65">����</td>
			      <td class="title" width="100">�ں�</td>
			      <td width="100" align="center"><%=ht.get("OVER_CASH1_DT")%></td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CASH1_AMT"))%></td>
			      <td width="270" align="center"><%if(over_cash1_file.equals("")){%>
				  <a href="javascript:scan_reg('1');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
				  <%}else{%>
				  <%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
					 <a href="javascript:openPopF('<%=file_type1%>','<%=seq1%>');" title='����' ><%=over_cash1_file%></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=over_cash1_file%></a>
					 <%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					 <%}%>
					</td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CASH1_CR_AMT"))%></td>
			      <td width="100" align="center"><%=ht.get("OVER_CASH1_CR_DT")%></td>
			      <td width="100" align="center"><%=ht.get("OVER_CASH1_CR_JPNO")%></td>
			  </tr>
				<tr>
				  <td class="title" width="100">���ޱ�</td>
			      <td width="100" align="center"><%=ht.get("OVER_S_CASH1_DT")%></td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_S_CASH1_AMT"))%></td>
			      <td width="270" align="center"><%if(over_s_cash1_file.equals("")){%>
				  <a href="javascript:scan_reg('2');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
				 <%}else{%>
				   <%if(file_type2.equals("image/jpeg")||file_type2.equals("image/pjpeg")||file_type2.equals("application/pdf")){%>
					 <a href="javascript:openPopF('<%=file_type2%>','<%=seq2%>');" title='����' ><%=over_s_cash1_file%></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq2%>" target='_blank'><%=over_s_cash1_file%></a>
					 <%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq2%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					 <%}%>
				  </td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_S_CASH1_CR_AMT"))%></td>
			      <td class="title" width="100"></td>
			      <td width="100" align="center"><%=ht.get("OVER_S_CASH1_CR_JPNO")%></td>
			  </tr>
			  <tr>
					<td rowspan="3" class="title" width="50">����<br>�����</td>
					<td colspan="2" class="title" width="12.5%">����ī��</td>
					<td width="100" align="center"><%=ht.get("OVER_CARD2_DT")%></td>
					<td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CARD2_AMT"))%></td>
					<td colspan="4" class="title" width="12.5%"></td>
				</tr>
				<tr>
				  <td rowspan="2" class="title" width="50">����</td>
			      <td class="title" width="100">�ں�</td>
			      <td width="100" align="center"><%=ht.get("OVER_CASH2_DT")%></td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CASH2_AMT"))%></td>
			      <td width="270" align="center"><%if(over_cash2_file.equals("")){%>
				  <a href="javascript:scan_reg('3');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
				  <%}else{%>
				  <%if(file_type3.equals("image/jpeg")||file_type3.equals("image/pjpeg")||file_type3.equals("application/pdf")){%>
					 <a href="javascript:openPopF('<%=file_type3%>','<%=seq3%>');" title='����' ><%=over_cash2_file%></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq3%>" target='_blank'><%=over_cash2_file%></a>
					 <%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq3%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					 <%}%>	
					</td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CASH2_CR_AMT"))%></td>
			      <td width="100" align="center"><%=ht.get("OVER_CASH2_CR_DT")%></td>
			      <td width="100" align="center"><%=ht.get("OVER_CASH2_CR_JPNO")%></td>
			  </tr>
				<tr>
				  <td class="title" width="100">���ޱ�</td>
			      <td width="100" align="center"><%=ht.get("OVER_S_CASH2_DT")%></td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_S_CASH2_AMT"))%></td>
			      <td width="270" align="center"><%if(over_s_cash2_file.equals("")){%>
				  <a href="javascript:scan_reg('4');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
				  <%}else{%>
				   <%if(file_type4.equals("image/jpeg")||file_type4.equals("image/pjpeg")||file_type4.equals("application/pdf")){%>
					 <a href="javascript:openPopF('<%=file_type4%>','<%=seq4%>');" title='����' ><%=over_s_cash2_file%></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq4%>" target='_blank'><%=over_s_cash2_file%></a>
					 <%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq4%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					 <%}%>
				  </td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_S_CASH2_CR_AMT"))%></td>
			      <td class="title" width="100"></td>
			      <td width="100" align="center"><%=ht.get("OVER_S_CASH2_CR_JPNO")%></td>
			  </tr>
			  <tr>
					<td rowspan="3" class="title" width="65">��Ÿ</td>
					<td colspan="2" class="title" width="150">����ī��</td>
					<td width="100" align="center"><%=ht.get("OVER_CARD3_DT")%></td>
					<td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CARD3_AMT"))%></td>
					<td colspan="4" class="title"  width="12.5%"></td>
				</tr>
				<tr>
				  <td rowspan="2" class="title" width="65">����</td>
			      <td class="title" width="100">�ں�</td>
			      <td width="100" align="center"><%=ht.get("OVER_CASH3_DT")%></td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CASH3_AMT"))%></td>
			      <td width="270" align="center"><%if(over_cash3_file.equals("")){%>
				  <a href="javascript:scan_reg('5');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
				  <%}else{%>
				  <%if(file_type5.equals("image/jpeg")||file_type5.equals("image/pjpeg")||file_type5.equals("application/pdf")){%>
					 <a href="javascript:openPopF('<%=file_type5%>','<%=seq5%>');" title='����' ><%=over_cash3_file%></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq5%>" target='_blank'><%=over_cash3_file%></a>
					 <%}%>
					 &nbsp;<a href="'https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq5%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					  <%}%>
					</td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CASH3_CR_AMT"))%></td>
			      <td width="100" align="center"><%=ht.get("OVER_CASH3_CR_DT")%></td>
			      <td width="100" align="center"><%=ht.get("OVER_CASH3_CR_JPNO")%></td>
			  </tr>
				<tr>
				  <td class="title" width="12.5%">���ޱ�</td>
			      <td width="100" align="center"><%=ht.get("OVER_S_CASH3_DT")%></td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_S_CASH3_AMT"))%></td>
			      <td width="270" align="center"><%if(over_s_cash3_file.equals("")){%>
				  <a href="javascript:scan_reg('6');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
					<%}else{%>
				   <%if(file_type6.equals("image/jpeg")||file_type6.equals("image/pjpeg")||file_type6.equals("application/pdf")){%>
					 <a href="javascript:openPopF('<%=file_type6%>','<%=seq6%>');" title='����' ><%=over_s_cash3_file%></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq6%>" target='_blank'><%=over_s_cash3_file%></a>
					 <%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq6%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					  <%}%>
				  </td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_S_CASH3_CR_AMT"))%></td>
			      <td class="title" width="12.5%"></td>
			      <td width="100" align="center"><%=ht.get("OVER_S_CASH3_CR_JPNO")%></td>
			  </tr>
			  <tr>
					<td rowspan="3" class="title" width="65">�հ�</td>
					<td colspan="2" class="title" width="165">����ī��</td>
					<td width="100" class="title"></td>
					<td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CARD_TOT"))%></td>
					<td colspan="4" class="title" width="600"></td>
				</tr>
				<tr>
				  <td rowspan="2" class="title" width="50">����</td>
			      <td class="title" width="12.5%">�ں�</td>
			      <td width="100" class="title"></td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_CASH_TOT"))%></td>
			      <td width="100" class="title"></td>
			      <td width="100" class="title"></td>
			      <td width="100" class="title"></td>
			      <td width="100" class="title"></td>
			  </tr>
				<tr>
				  <td class="title" width="100">���ޱ�</td>
			      <td width="100" class="title"></td>
			      <td width="100" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_S_CASH_TOT"))%></td>
			      <td width="100" class="title"></td>
			      <td width="100" class="title"></td>
			      <td class="title" width="100"></td>
			      <td width="100" class="title"></td>
			  </tr>
        	</table>
        </td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����(�޹���)�ٷμ��� ����</span>&nbsp;&nbsp;&nbsp;&nbsp;<font color=red size=2>(����޿� �� ���� �Է��� �޿�����ڰ� �Է��ϰ� ����Ŭ���ϸ� ��ϵ�)</font> </td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td rowspan="2" width="50" class="title">�ٷ�<br>����<br>(����)</td>
					<td width="150" class="title">�����</td>
					<td colspan="6" width="600" align="center">���� = �����޿� �� 209(�ð�) �� �ٷνð� �� ������(150%)</td>
				</tr>
				<tr>
					<td class="title" width="150">�ñ޻������� �ð����� ����ٰ�</td>
					<td colspan="6" width="600" align="center">1)��5�� �ٷ�&nbsp;&nbsp;&nbsp;2)1�� 8�ð� �ٷ�&nbsp;&nbsp;&nbsp;3)������� ���� </td>
				</tr>
<!--				
<%	if(nm_db.getWorkAuthUser("�ӿ�",us_id) || nm_db.getWorkAuthUser("������",us_id)){%>

				<tr>
					<td colspan="2" class="title" width="250">����޿� </td>
					<td colspan="2" width="133" align="right"><INPUT TYPE="text" NAME="over_scgy" size="20" value="<%=ht.get("OVER_SCGY")%>" >�� </td>
					<td width="133" class="title">���޿������� </td>
					<td width="133" align="center">&nbsp;<INPUT TYPE="text" NAME="over_scgy_dt" size="15" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%=ht.get("OVER_SCGY_DT")%>"></td>
					<td width="133" class="title">PL������� </td>
					<td width="133" align="center">&nbsp;<INPUT TYPE="text" NAME="over_scgy_pl_dt" size="15" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%=ht.get("OVER_SCGY_PL_DT")%>"></td>
				</tr>
				
<%}else{%>		
		
				<tr>
					<td colspan="2" class="title" width="250">����޿� </td>
					<td colspan="2" width="133" align="right"><%=AddUtil.parseDecimal(ht.get("OVER_SCGY"))%>�� </td>
					<td width="133" class="title">���޿������� </td>
					<td width="133" align="center">&nbsp;<%=ht.get("OVER_SCGY_DT")%></td>
					<td width="133" class="title">PL������� </td>
					<td width="133" align="center">&nbsp;<%=ht.get("OVER_SCGY_PL_DT")%></td>
				</tr>
				
<%}%>			
-->	
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="12.5%" rowspan="2" class="title">����<br>(�λ�μ�)</td>
					<td width="12.5%" align="center" class="title">�λ���</td>
					<td width="12.5%" align="center" class="title">�޿����</td>
					<td width="12.5%" align="center" class="title">�ѹ�����</td>
					<td width="12.5%" align="center" class="title"></td>
					<td width="12.5%" align="center" class="title"></td>
					<td width="12.5%" align="center" class="title"></td>
					<td width="12.5%" align="center" class="title"></td>					
				</tr>
				<tr>
				  <td width="12.5%" align="center">�λ�����<br>�Ⱥ���<br><%if(ht.get("T_CHECK").equals("")){%>
	  	<%	if(nm_db.getWorkAuthUser("�ӿ�",us_id) || nm_db.getWorkAuthUser("������",us_id)){%>
				  	<a href='javascript:time_ok()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align=absmiddle border=0></a>
		<%}%> 		  	
				  	<%}else{%><%=ht.get("USER_DT7")%><%}%></td>
				  <td width="12.5%" align="center"><!--�޿������<br>�Ⱥ���<br><%if(ht.get("T_CHECK1").equals("")){%><%if(ht.get("T_CHECK").equals("Y")){%>
		<%	if(nm_db.getWorkAuthUser("�ӿ�",us_id) || nm_db.getWorkAuthUser("������",us_id)){%>				  	
				  	<a href='javascript:time_ok1()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align=absmiddle border=0></a>
		<%}%>		  	
				  	<%}}else{%><%=ht.get("T_CHECK1_DT")%><%}%> --></td>
				  
<input type='hidden' name="over_scgy" 	value="<%=over_scgy%>">
<input type='hidden' name="over_scgy_dt" 	value="<%=over_scgy_dt%>">
<input type='hidden' name="over_scgy_pl_dt" 	value="<%=over_scgy_pl_dt%>">				  

			      <td width="12.5%" align="center">&nbsp;</td>
			      <td width="12.5%" align="center">&nbsp;</td>
			      <td width="12.5%" align="center">&nbsp;</td>
			      <td width="12.5%" align="center">&nbsp;</td>
			      <td width="12.5%" align="center">&nbsp;</td>

			  </tr>
			</table>
		</td>
	</tr>

	<tr>
		<td class=h></td>
	</tr>
		<tr>
		<td class=h></td>
	</tr>
	<%}}%>	
	<tr> 
         <td colspan="2" align='right'> 
  	<%	if(nm_db.getWorkAuthUser("������",us_id)||nm_db.getWorkAuthUser("�ӿ�",us_id)){%>			      	
        &nbsp;<a href='javascript:Over_time_del()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align=absmiddle border=0></a>
<%}%>        
<!-- 		&nbsp;<a href='javascript:Over_time_close()'><img src="/acar/images/center/button_close.gif" align=absmiddle border=0></a> -->

</td> 
	</tr>
</TABLE>

					

</form>
<iframe src="about:blank" name="i_no" width="0 height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</BODY>

</HTML>

