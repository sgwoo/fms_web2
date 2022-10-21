<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.fee.*, acar.client.*, acar.cont.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	// �α��� ����
	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_m_tel 	= login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}
   	
   	String s_kd 		= request.getParameter("s_kd")		==	null ? "" : request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==	null ? "" : request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")		==	null ? "" : request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")		==	null ? "" : request.getParameter("gubun1");
	String gubun4 	= request.getParameter("gubun4")		==	null ? "1" : request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")		==	null ? "1" : request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		== 	null ? "" : request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")		==	null ? "" : request.getParameter("end_dt");
	String b_trf_yn 		= request.getParameter("b_trf_yn")		==	null ? "" : request.getParameter("b_trf_yn");

	Vector vt = ln_db.getDeliEdocMngList(gubun1, gubun4, gubun5, st_dt, end_dt, s_kd, t_wd, b_trf_yn);
	int vt_size = vt.size();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS - ���ڹ��� �߼�</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style type="text/css">
.list-area td{
	text-align: center;
}
.font-1 {
    font-family:����, Gulim, AppleGothic, Seoul, Arial;
    font-size: 9pt;
    font-weight: bold;
}
.font-2 {
    font-family:����, Gulim, AppleGothic, Seoul, Arial;
    font-size: 9pt;
}
.width-1 {
    width: 200px;
}
.width-2 {
    width: 250px;
}
.width-3 {
    width: 300px;
    padding: 2px;
    margin-bottom: 3px;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
	function searchList(){
		var fm = document.form1;
		fm.submit();
	}

	// pdf ���� ����
	function viewFile(end_file){
		window.open(end_file);
	}
</script>
</head>
<body style='margin: 0;'>
<form name='form1' action='' method='post'>
<input type='hidden' id='user_id' name='user_id' value='<%=user_id%>' />

<!-- Ÿ��Ʋ ���� -->
<div style='margin: 0 15px; display: inline-block; '>
	<div class='e-doc-title'>
		<h2>�ε��μ���</h2>
	</div>
</div>

<!-- �˻� ���� -->
<div class='search-area' style='margin: 0px 15px;'>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
		</tr>
		<tr>
			<td class=line2></td>
		</tr>
		<tr>
			<td class=line>
				<table border="0" cellspacing="1" cellpadding='0' width=100%>
					<tr>
						<td class="title" width=10%>��ȸ����</td>
						<td width="40%" colspan='3'>&nbsp;
							<select name='gubun4'>
								<option value="1" <%if(gubun4.equals("1"))%>selected<%%>>�۽�����</option>
							</select>
							&nbsp;
							<select name='gubun5'>
								<option value="1" <%if(gubun5.equals("1"))%>selected<%%>>����</option>
								<option value="2" <%if(gubun5.equals("2"))%>selected<%%>>����</option>
								<option value="3" <%if(gubun5.equals("3"))%>selected<%%>>2��</option>
								<option value="4" <%if(gubun5.equals("4"))%>selected<%%>>���</option>
								<option value="5" <%if(gubun5.equals("5"))%>selected<%%>>����</option>
								<option value="6" <%if(gubun5.equals("6"))%>selected<%%>>�Ⱓ</option>
							</select>
							&nbsp;
							<input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
							~
							<input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">
						</td>
					</tr>
					<tr>
						<td class=title width=10%>�˻�����</td>
						<td>&nbsp;
							<select name='s_kd'>
								<option value='1'  <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ</option>
								<option value='2'  <%if(s_kd.equals("2")){%>selected<%}%>>������ȣ</option>
								<option value='3'  <%if(s_kd.equals("3")){%>selected<%}%>>����</option>
								<option value='4'  <%if(s_kd.equals("4")){%>selected<%}%>>�۽���</option>
								<option value='5'  <%if(s_kd.equals("5")){%>selected<%}%>>Ź�۹�ȣ</option>
								<option value='6'  <%if(s_kd.equals("6")){%>selected<%}%>>Ź�۾�ü</option>
							</select>
							&nbsp;
							<input type='text' name='t_wd' size='30' class='text' value='<%=t_wd%>'>
						</td>
						<td width=50% colspan='2'>&nbsp;
							<input type='checkbox' id='b_trf_yn' name='b_trf_yn' value='Y' <%if(b_trf_yn.equals("Y")){ %>checked<%} %>/>
							<label for='b_trf_yn'>ä�Ǿ絵������ �� ������ �ִ� �͸� �˻�</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr align="right">
			<td>
				<a href="javascript:searchList();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
			</td>
		</tr>
	</table>
</div>

<!-- ����Ʈ ���� -->
<div class='list-area' style='margin: 0px 15px;'>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
		    <td class=h></td>
		</tr>
		<tr>
	        <td class=line2></td>
	    </tr>
	    <tr>
	    	<td class='line'>
	    	<table border=0 cellspacing=1 width=100%>
	    		<tr>
	    			<td class='title title_border' rowspan='2'>����</td>
	    			<td class='title title_border' rowspan='2'>Ź�۹�ȣ</td>
	    			<td class='title title_border' rowspan='2'>Ź�۾�ü</td>
	    			<td class='title title_border' rowspan='2'>��ȣ</td>
	    			<td class='title title_border' colspan='2'>�ڵ���</td>
	    			<td class='title title_border' rowspan='2'>�۽���</td>
	    			<td class='title title_border' rowspan='2'>�۽�����</td>
	    			<td class='title title_border' rowspan='2'>ó��</td>
	    			<td class='title title_border' rowspan='2'>���۱���</td>
	    			<td class='title title_border' rowspan='2'>�Ϸ�����</td>
	    			<td class='title title_border' rowspan='2'>PDF����</td>
	    		</tr>
	    		<tr>
	    			<td class='title title_border'>����</td>
	    			<td class='title title_border'>������ȣ</td>
	    		</tr>
	    		<%if(vt_size > 0){ %>
	    			<%for(int i=0; i<vt_size; i++){ 
	    				Hashtable ht = (Hashtable)vt.elementAt(i);
	    			%>
	    		<tr>
	    			<td><%=i+1%></td>
	    			<td><%=ht.get("CONS_NO")%></td>
	    			<td><%=ht.get("OFF_NM")%></td>
	    			<td><%=ht.get("FIRM_NM")%></td>
	    			<td><%=ht.get("CAR_NM")%></td>
	    			<td><%=ht.get("CAR_NO")%></td>
	    			<td><%=ht.get("USER_NM")%></td>
	    			<td><%=ht.get("REG_DT")%></td>
	    			<td><%=ht.get("USE_YN")%></td>
	    			<td><%=ht.get("SEND_TYPE")%></td>
	    			<td><%=ht.get("END_DT")%></td>
	    			<td>
	    				<%if(!String.valueOf(ht.get("END_FILE")).equals("")){ %>
	    					<input type='button' class='button' value='����' onclick="javascript:viewFile('<%=ht.get("END_FILE")%>');" />
		    			<%} %>
	    			</td>
	    		</tr>
	    			<%} %>
	    		<%}else{ %>
	  			<tr>
					<td class='center content_border' colspan='14' style='text-align: center;'>��ϵ� �����Ͱ� �����ϴ�</td>
				</tr>	
    			<%} %>
	    	</table>
	    	</td>
	    </tr>
	</table>
</div>
</form>
</body>

</script>
</html>