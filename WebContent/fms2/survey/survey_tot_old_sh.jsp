<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, dates.*"%>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun1 = request.getParameter("gubun1")==null?"���":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"�ű�":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
	Vector vt = p_db.getSurvey_All_list(gubun1, gubun2);
	int vt_size = vt.size();
	
	
	Vector polls = new Vector();
	
		
	if(gubun1.equals("���")){
		polls = p_db.getOld_livePoll_question( gubun1, gubun2);
	}else if(gubun1.equals("��ȸ����")){
		polls = p_db.getSurveyServicePollTot();
	}else if(gubun1.equals("���ó��")){
		polls = p_db.getSurveyAccidentPollTot();
	}
	int poll_size = polls.size();
	
	if(ref_dt1.equals("")&&ref_dt2.equals("")){
	Calendar today = Calendar.getInstance();   

	int year = today.get(Calendar.YEAR);
    int month = today.get(Calendar.MONTH)+1;
    
	
	int date = today.get(Calendar.DATE);

	int lastDay = today.getActualMaximum(Calendar.DATE);
	
	if(month <10 ) {
		ref_dt1 = year+"-0"+month+"-01";
		ref_dt2 = year+"-0"+month+"-"+lastDay;
	}else{
		ref_dt1 = year+"-"+month+"-01";
		ref_dt2 = year+"-"+month+"-"+lastDay;
	}
	
	
	}
	
	
%>
<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function ChangeDT(arg)
{
	var theForm = document.RentCondSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}


//�������̵�
	function move_page(){  
		var fm = document.form1;
		
		fm.action = 'survey_tot_old_sh.jsp';
		
		fm.target = "_self";
		fm.submit();
	}	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
select {
    width: 40%;
    padding: 4px 8px;
    border: 1px solid ;
    border-radius: 4px;
    background-color: #ffff;
	font-size: 1em;
}
</style>
</head>
<body>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<script>
$(function() {
	$("#gubun2").chained("#gubun1");
});
</script>
<script>

function fnPopUp(el, url, polltype, pollst, pollseq, ex, gubun1, gubun2, gubun3) {
 newwindow=window.open(url+'?poll_type='+polltype+'&poll_st='+pollst+'&poll_seq='+pollseq+'&a_seq='+ex+'&poll_type='+gubun1+'&poll_st='+gubun2+'&poll_su='+gubun3,'survey_pop','height=700,width=900,scrollbars=yes');

}


	
		
</script>
</head>
<body>

<form name='form1' action='survey_tot_old_sh.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 

<div class="navigation">
	<span class=style1>�ݼ��� ></span><span class=style5>�� ��� �����Ȳ </span>
</div>

<div class="search-area">
	<label><i class="fa fa-check-circle"></i> ���� </label>
		<select id="gubun1" name="gubun1" class="select" style="width:150px;">
			<option value = "" <%if(gubun1.equals(""))%>selected<%%>> ���� </option>
			<option value = "���" <%if(gubun1.equals("���"))%>selected<%%>>���</option>
			<option value = "��ȸ����" <%if(gubun1.equals("��ȸ����"))%>selected<%%>>��ȸ����</option>
			<option value = "���ó��" <%if(gubun1.equals("���ó��"))%>selected<%%>>���ó��</option>
		</select>
	<label><i class="fa fa-check-circle"></i> ���Ÿ�� </label>
		<select id="gubun2" name="gubun2" class="select" style="width:150px;" onblur="move_page();">
			<option value = ""  <%if(gubun2.equals("")){out.print("selected");}%>> ���� </option>
			<option class="���" value = "�ű�"  <%if(gubun2.equals("�ű�")){out.print("selected");}%>> �ű� </option>
			<option class="���" value = "����"  <%if(gubun2.equals("����")){out.print("selected");}%>> ���� </option>
			<option class="���" value = "����"  <%if(gubun2.equals("����")){out.print("selected");}%>> ���� </option>
			<option class="���" value = "�縮��"  <%if(gubun2.equals("�縮��")){out.print("selected");}%>> �縮�� </option>
			<option class="���" value = "����Ʈ"  <%if(gubun2.equals("����Ʈ")){out.print("selected");}%>> ����Ʈ </option>
			<option class="��ȸ����" value = "��ȸ����"  <%if(gubun2.equals("��ȸ����")){out.print("selected");}%>> ��ȸ���� </option>
			<option class="���ó��" value = "���ó��"  <%if(gubun2.equals("���ó��")){out.print("selected");}%>> ���ó�� </option>
		</select>
	
		<label><i class="fa fa-check-circle"></i> �Ⱓ </label>
		<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
		~ 
		<input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" > 
	
		<input type="button" class="button button4" value="�˻�" onclick="move_page()"/>
</div>	
<table border="0" cellspacing="0" cellpadding="0" width="100%">	
	<tr>
        <td align="right">�� ��� �� <%//=poll_size%>��</td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border=0 cellspacing=1 width="100%">
                <tr>
					<td class=line width="100%">
						<table border=0 cellspacing=1 width="100%">
							<tr>
								<td width=27% class=title height="150">����</td>
								<td width=5% class=title height="150">�����</td>				  
								<td width=5% class=title height="150">�հ�</td>
							</tr>
						</table>
					</td>
				</tr>
    		<%if(poll_size > 0){%>
                <tr>
					<td class=line width="100%">
						<table border=0 cellspacing=1 width="100%">
						<%
							for(int i = 0 ; i < poll_size ; i++){
								Hashtable qu = (Hashtable)polls.elementAt(i);
							
								int tot_cnt = 0;
								%>
							<tr>
								<td align=left width="27%" height="150" style="background-color:lightblue;"  ><b>Q<%=qu.get("POLL_SEQ")%>. <%=qu.get("QUESTION")%><b/></td>
								<td align=center width="5%"  height="150" style="background-color:lightblue;" ></td>
								<td align=center width="5%" height="150" style="background-color:lightblue;" ></td>
							</tr>
						<%
						Vector ans = new Vector();
							ans = p_db.getOld_livePoll_answers((String)qu.get("POLL_TYPE"), (String)qu.get("POLL_ST"), (String)qu.get("POLL_SEQ"));
							int ans_size = ans.size();
							for(int j = 0 ; j < ans_size ; j++){
								Hashtable an = (Hashtable)ans.elementAt(j);
								
								Hashtable ht = p_db.getOld_poll_count((String)an.get("POLL_SEQ"), (String)an.get("EX"), ref_dt1, ref_dt2);
								int count = 0;
								count = AddUtil.parseInt((String)ht.get("CNT"));
								
								tot_cnt += count;
						%>
							<tr>
								<td align=left width="27%" height="150" >&nbsp;&nbsp;&nbsp;<%=an.get("ANSWER")%></td>
								<td align=center width="5%"  height="150"></td>
								<td align=center width="5%" height="150">
								<a href="javascript:fnPopUp(this, 'survey_pop_old.jsp', '<%=an.get("POLL_TYPE")%>','<%=an.get("POLL_ST")%>','<%=an.get("POLL_SEQ")%>','<%=an.get("EX")%>','<%=gubun1%>','<%=gubun2%>','<%=gubun3%>')" style="text-decoration:none">
								<%=count%>
								</a>
								</td>
							</tr>
							<%}%>
							<tr>
								<td colspan="2" class="title"> �հ� </td>
								<td class="title"><%=tot_cnt%></td>
							</td>
						<%}%>
						
						</table>
					</td>
				</tr>
            <%}else{%>
                <tr> 
                    <td colspan=4 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
            <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
