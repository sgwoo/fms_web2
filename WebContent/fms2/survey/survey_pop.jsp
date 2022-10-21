<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.call.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 		= request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String poll_type 	=  request.getParameter("poll_type")==null?"":request.getParameter("poll_type");
	String poll_st 		=  request.getParameter("poll_st")==null?"":request.getParameter("poll_st");
	String poll_su 		=  request.getParameter("poll_su")==null?"":request.getParameter("poll_su");
	String start_dt 	=  request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 		=  request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String poll_id 		=  request.getParameter("poll_id")==null?"":request.getParameter("poll_id");
	String poll_seq 	=  request.getParameter("poll_seq")==null?"":request.getParameter("poll_seq");
	String a_seq 		=  request.getParameter("a_seq")==null?"":request.getParameter("a_seq");
	String gubun1 		=  request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		=  request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		=  request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		=  request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String dt1 			=  request.getParameter("dt1")==null?"":request.getParameter("dt1");
	String dt2 			=  request.getParameter("dt2")==null?"":request.getParameter("dt2");
	String ref_dt1 		=  request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		=  request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
	
	
	//����+�亯
	Vector po = new Vector();
	po = p_db.getSurveyContPollView_listOne(poll_id, poll_seq, a_seq);
	int po_size = po.size();
	
	String table_nm = "";
	
	if(poll_type.equals("���")){
		table_nm = "CONT_CALL";
	}else if(poll_type.equals("��ȸ����")){
		table_nm = "SERVICE_CALL";
	}else if(poll_type.equals("���ó��")){
		table_nm = "ACCIDENT_CALL";
	}		
	
	
	//�����ڸ���Ʈ
	Vector pt = new Vector();
	pt = p_db.getSurveyContPollView_listTwo(poll_id, poll_seq, a_seq, table_nm, gubun4, ref_dt1, ref_dt2);
	int pt_size = pt.size();
%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>fms</title>
  <link rel="stylesheet" type="text/css" href="/include/table_t.css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">

 
function closeWin() {
    self.opener = self;
	window.close();
}

function view_cont(m_id, l_cd, poll_st, c_id, s_id, a_id)
	{
		var fm = document.form1; 
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.mode.value = '2'; /*��ȸ*/
		fm.g_fm.value = '1';
		fm.type.value = '2';
		fm.poll_st.value = poll_st;
		<%if(poll_type.equals("���")){%>
		fm.action = './survey_cont_reg_frame.jsp';
		<%}else if(poll_type.equals("��ȸ����")){%>
		fm.c_id.value = c_id;
		fm.s_id.value = s_id;
		fm.action = './survey_service_reg_frame.jsp';
		<%}else if(poll_type.equals("���ó��")){%>
		fm.c_id.value = c_id;
		fm.accid_id.value = a_id;
		
		fm.action = './survey_accident_reg_frame.jsp';
		<%}%>
		
		fm.submit();
	}
	
</script>
</head>
<body>
<form name='form1' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='s_id' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='g_fm' value='1'>
<input type='hidden' name='type' value='2'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='poll_st' value=''> 
<div class="navigation">
	<span class=style1>�ݼ��� ></span><span class=style5> �� ��� ������Ȳ </span>
</div>
<br>
<div align="center">

 <table class="table table-bordered" style="width:95%;">
	<thead>
	<%
		for(int i = 0 ; i < po_size ; i++){
			Hashtable po_ht = (Hashtable)po.elementAt(i);%>
		<tr>
			<th class="info" style="text-align: center;"><%if(po_ht.get("A_SEQ").equals("0")){%>����<%}else{%>�亯<%}%></th>
			<td><%=po_ht.get("CONTENT")%></td>				  
		</tr>
		<%}%>
	</thead>	
</table>
<p>
<table class="table table-bordered" style="width:95%;">
	<thead>
		<tr >
	       <th class="info" style="text-align: center;" width="6%">����</th>
			<th class="info" style="text-align: center;" width="18%">��ȣ</th>
			<th class="info" style="text-align: center;" width="17%">����</th>
			<th class="info" style="text-align: center;" width="9%">��������</th>
			<th class="info" style="text-align: center;" width="11%">�������</th>
			<th class="info" style="text-align: center;" width="11%">�亯����</th>
			<th class="info" style="text-align: center;" width="*">��������</th>
		</tr>
	</thead>
	
	<%
		for(int i = 0 ; i < pt_size ; i++){
			Hashtable pt_ht = (Hashtable)pt.elementAt(i);
			
			%>
		<tr>
			<td><%=i+1%></td>
			<td><a href="javascript:view_cont('<%=pt_ht.get("RENT_MNG_ID")%>','<%=pt_ht.get("RENT_L_CD")%>','<%=poll_st%>','<%=pt_ht.get("CAR_MNG_ID")%>','<%=pt_ht.get("SERV_ID")%>','<%=pt_ht.get("ACCID_ID")%>')"><%=pt_ht.get("FIRM_NM")%></a></td>
			<td><%=pt_ht.get("CAR_NM")%></td>
			<td><%=pt_ht.get("BUS_ST")%></td>
			<td><%=AddUtil.ChangeDate2(String.valueOf(pt_ht.get("RENT_DT")))%></td>
			<td><%=AddUtil.ChangeDate2(String.valueOf(pt_ht.get("ANSWER_DATE")))%></td>
			<td><%=pt_ht.get("ANSWER_REM")%></td>
		</tr>
		<%}%>

</table>
<div align="right"><input type="button" value="�ݱ�" class="button button4" onclick="closeWin()"/>&nbsp;&nbsp;&nbsp;&nbsp;</div>

</div>
</form>
</body>
</html>