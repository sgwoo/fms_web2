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
   	
   	String s_kd 		= request.getParameter("s_kd")		==	null ? "" 	: request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==	null ? "" 	: request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")		==	null ? "" 	: request.getParameter("gubun1");
	String gubun4 	= request.getParameter("gubun4")		==	null ? "1" 	: request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")		==	null ? "1" 	: request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		== 	null ? "" 	: request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")		==	null ? "" 	: request.getParameter("end_dt");
	
	Vector vt = ln_db.getLcEdocMngList(gubun1, gubun4, gubun5, st_dt, end_dt, s_kd, t_wd);
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
	// �˻�
	function searchList(){
		var fm = document.form1;
		fm.action = 'lc_doc_mng.jsp';	
		fm.target = '_self';
		fm.submit();
	
	}
	
	// ���� ���
	function discardDoc(doc_code){
		
		var check = window.confirm('��� �� ���� �������� ���� �Ǳ��� ��� ���Ǹ�, ��߼��� ���Ͻ� ��� ���� ���� �߼� �޴����� �߼� �� ó�� ������� �ٽ� �����ϼž� �մϴ�.\n\n�׷��� ����Ͻðڽ��ϱ�?');
		
		if(!check) return;
		
		var fm = document.form1;
		fm.doc_code.value = doc_code;
		fm.type.value = 'discard';
		fm.action = 'e_doc_mng_a.jsp';
		fm.submit();
	}
	
	// ���� �Ϸ� �� ���� ��߼�
	function resendDoc(doc_code){
		var check = window.confirm('������ �Է��Ͻ� ���� ����(���� ���� �Ǵ� ����ó)�� ��߼۵˴ϴ�.\n���� ���� ������ ���Ͻø� ���� ������ ����� �� ���ڹ��� �߼� �޴����� ��߼��Ͻñ� �ٶ��ϴ�.\n\n�߼��Ͻðڽ��ϱ�?');
		
		if(!check) return;
		
		var fm = document.form1;
		fm.doc_code.value = doc_code;
		fm.type.value = 'resend';
		
		fm.action = 'e_doc_mng_a.jsp';
		fm.submit();
	}
	
	// ���� �Ϸ� ���� ����� Ȯ�ο� �߼�
	function sendCompletedDoc(doc_code){
		var check = window.confirm('���� �Ϸ� ������ �߼��Ͻðڽ��ϱ�?');
		
		if(!check) return;
		
		var fm = document.form1;
		fm.type.value = 'completed';
		fm.doc_code.value = doc_code;
		
		fm.action = 'e_doc_mng_a.jsp';
		fm.submit();
	}

	// pdf ���� ����
	function viewFile(end_file){
		window.open(end_file);
	}
	
	//��༭ ����  - (�ش� ���� �ٷ� up)
	function file_up(urlfile, m_id, l_cd, rent_st, reg_id){
		
		var fm = document.form1;
		var SUMWIN = "";		
		
		window.open(SUMWIN, "upfile", "left=50, top=50, width=500, height=400, scrollbars=yes, status=yes");		
						
		fm.target = "upfile";
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact_edoc.jsp?mrent=N&urlfile="+urlfile+"&m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st+"&reg_id="+reg_id;
		fm.submit();		

	}
	

</script>
</head>
<body style='margin: 0;'>
<form name='form1' action='' method='post'>
<input type='hidden' id='user_id' name='user_id' value='<%=user_id%>' />
<input type='hidden' id='doc_code' name='doc_code' value='' />
<input type='hidden' id='type' name='type' value='' />

<!-- Ÿ��Ʋ ���� -->
<div style='margin: 0 15px; display: inline-block; '>
	<div class='e-doc-title' >
		<h2>��� ��༭</h2>
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
						<td width="40%">&nbsp;
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
						<td class=title width=10%>����</td>
						<td width=40%>&nbsp;
							<select name='gubun1'>
								<option value=''  <%if(gubun1.equals("")){ %>selected<%}%>>��ü </option>
								<option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>��� ��༭</option>
								<option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>�°� ��༭</option>
								<option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>���� ��༭</option>
							</select>&nbsp;
						</td>
					</tr>
					<tr>
						<td class=title width=10%>�˻�����</td>
						<td colspan='3'>&nbsp;
							<select name='s_kd'>
								<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ</option>
								<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ</option>
								<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ</option>
								<option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>����</option>
								<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>�۽���</option>
							</select>
							&nbsp;
							<input type='text' name='t_wd' size='30' class='text' value='<%=t_wd%>'>
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
	    			<td class='title title_border' rowspan='2'>������</td>
	    			<td class='title title_border' rowspan='2'>��౸��</td>
	    			<td class='title title_border' rowspan='2'>����ȣ</td>
	    			<td class='title title_border' rowspan='2'>��ȣ</td>
	    			<td class='title title_border' colspan='2'>�ڵ���</td>
	    			<td class='title title_border' rowspan='2'>�۽���</td>
	    			<td class='title title_border' rowspan='2'>�۽�����</td>
	    			<td class='title title_border' rowspan='2'>��ȿ�Ⱓ</td>
	    			<td class='title title_border' rowspan='2'>ó��</td>
	    			<td class='title title_border' rowspan='2'>���۱���</td>
	    			<td class='title title_border' rowspan='2'>�����ڱ���</td>
	    			<td class='title title_border' rowspan='2'>������</td>
	    			<td class='title title_border' rowspan='2'>�Ϸ�����</td>
	    			<td class='title title_border' colspan='2'>����</td>
	    			<td class='title title_border' rowspan='2'>���</td>
	    			<td class='title title_border' rowspan='2'>��߼�</td>
	    			<td class='title title_border' rowspan='2'>�ϷṮ��<br>�߼�</td>
	    		</tr>
	    		<tr>
	    			<td class='title title_border'>����</td>
	    			<td class='title title_border'>������ȣ</td>
	    			<td class='title title_border'>PDF ����</td>
	    			<td class='title title_border'>��ĵ���</td>
	    		</tr>
	    		<%if(vt_size > 0){ %>
	    			<%for(int i=0; i<vt_size; i++){ 
	    				Hashtable ht = (Hashtable)vt.elementAt(i);
	    			%>
		    		<tr>
		    			<td><%=i+1%></td>
		    			<td><%=ht.get("DOC_NAME")%></td>
		    			<td><%=ht.get("RENT_TYPE")%></td>
		    			<td><%=ht.get("RENT_L_CD")%></td>
		    			<td><%=ht.get("FIRM_NM")%></td>
		    			<td><%=ht.get("CAR_NM")%></td>
		    			<td><%=ht.get("CAR_NO")%></td>
		    			<td><%=ht.get("USER_NM")%></td>
		    			<td><%=ht.get("REG_DT")%></td>
		    			<td><%=ht.get("TERM_DT")%></td>
		    			<td><%=ht.get("USE_YN")%></td>
		    			<td><%=ht.get("SEND_TYPE")%></td>
		    			<td><%=ht.get("SIGN_ST")%></td>
		    			<td><%=ht.get("SIGN_TYPE")%></td>
		    			<td><%=ht.get("END_DT")%></td>
		    			<td><!-- PDF ���� ���� -->
		    				<%if( !String.valueOf(ht.get("END_DT")).equals("") && !String.valueOf(ht.get("END_FILE")).equals("") ){  // ���� �Ϸ� �� PDF ���� ������ �Ǹ� ��ư ����  %>
		    					<input type='button' class='button' value='����' onclick="javascript:viewFile('<%=ht.get("END_FILE")%>');" />
		    				<%} %>	
		    		    </td>
		    		    <td><!-- ���� ��ĵ ��� -->
		    		    <%if( !String.valueOf(ht.get("END_DT")).equals("") && !String.valueOf(ht.get("END_FILE")).equals("") ){  // ���� �Ϸ� �� PDF ���� ������ �Ǹ� ��ư ����  %>		
		    			 <% if (nm_db.getWorkAuthUser("������",user_id)) { %> <!--  ht.get("FEE_RENT_ST")  -->
		    				    &nbsp;<input type="button" class="button" id='downfile' value='��ĵ���' onclick="javascript:file_up('<%=ht.get("END_FILE")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>', '<%=user_id%>')">	  
		    			 <% } %>
		    			<%} %>					    			
		    			</td>
		    			<td>	<!-- ��� -->
		    				<%if( String.valueOf(ht.get("USE_YN")).equals("���") ){ %>
		    					<%if( String.valueOf(ht.get("END_DT")).equals("") ){ // ���� �Ϸ���� ���� �Ǹ� ��ư ���� %>
			    				<input type='button' class='button' value='���' onclick="javascript:discardDoc('<%=ht.get("DOC_CODE")%>');" />
			    				<%} %>
		    				<%} %>
		    			</td>
		    			<td>	<!-- ���� �Ϸ� �� ��߼� -->
		    				<%if( String.valueOf(ht.get("USE_YN")).equals("���") ){ %>
			    				<%if( String.valueOf(ht.get("END_DT")).equals("") ){ // ���� �Ϸ���� ���� �Ǹ� ��ư ���� %>
			    				<input type='button' class='button' value='��߼�' onclick="javascript:resendDoc('<%=ht.get("DOC_CODE")%>');" />
			    				<%} %>
		    				<%} %>
		    			</td>
		    			<td>	<!-- �Ϸ� ���� �߼� -->
		    				<%if( String.valueOf(ht.get("USE_YN")).equals("���") ){ %>
		    					<%if( !String.valueOf(ht.get("END_DT")).equals("") && !String.valueOf(ht.get("END_FILE")).equals("")){ // ���� �Ϸ� �� PDF ���� ������ �Ǹ� ��ư ���� %>
		    					<input type='button' class='button' value='�߼�' onclick="javascript:sendCompletedDoc('<%=ht.get("DOC_CODE")%>');" />
		    					<%} %>
		    				<%} %>
		    			</td>
		    		</tr>
	    			<%} %>
	    		<%}else{ %>
	  			<tr>
					<td class='center content_border' colspan='20' style='text-align: center;'>��ϵ� �����Ͱ� �����ϴ�</td>
				</tr>	
	    		<%} %>
	    	</table>
	    	</td>
	    </tr>
	</table>
</div>
</form>
</body>

</html>
