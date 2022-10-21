<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String gubun1	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String s_year	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	
	int st_year 	= request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int st_mon 	= request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
	int year 	= AddUtil.getDate2(1);
	
	
	String mtel_scan_file = "";	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	

	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	u_bean = umd.getUsersBean(ck_acar_id);
	String user_nm = u_bean.getUser_nm();
	String dept_id = u_bean.getDept_id();
	String dept_nm = u_bean.getDept_nm();
	String id = u_bean.getId();
	
	Vector vt = ac_db.Year_jungsan_List(s_year, user_nm, "");
	int vt_size = vt.size();
	
	String END_DT = "";
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		END_DT = (String)ht.get("END_DT");
	}	
%>

<HTML>
<HEAD>
<TITLE>�������</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
function save()
{
	var fm = document.form1;
	
	/*
	if(fm.file_name1.value == ''){	alert('�ٷμҵ��� �ҵ�-���װ��� �Ű��� PDF�� ��ĵ�� �� ����Ͻʽÿ�.'); 	fm.file_name1.focus(); 	return; }
	if(fm.file_name2.value == ''){	alert('����û���� �ٿ����(PDF) ������ ����Ͻʽÿ�.'); 	fm.file_name2.focus(); 	return; }
	
	*/
	//��ĵ���� Ȯ���ڰ� ".PDF" ��ġ üũ 
	
	var file = fm.file_name1.value;
	var file2 = fm.file_name2.value;
	
	file = file.slice(file.indexOf("\\") +1 );
	file2 = file2.slice(file2.indexOf("\\") +1 );
	
	ext = file.slice(file.indexOf(".")).toLowerCase();
	ext2 = file2.slice(file2.indexOf(".")).toLowerCase();
	
	if(ext != '.pdf' && ext2 != '.pdf'){
		alert('PDF�� �ƴմϴ�. PDF�� ��ĵ�� ���ϸ� ����� �����մϴ�.'); 	
		fm.file_name1.focus(); 	
		return;
	}
	

	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	
	
	
	fm.target = "i_no";
	fm.action = "https://fms3.amazoncar.co.kr/fms2/year_jungsan/year_scan_a.jsp";	
	fm.submit();
}
function free_close()
{
	var theForm = opener.document.form1;
	theForm.submit();
	self.close();
	window.close();
}

function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

//-->
</script>
<script type="text/javascript">
<!-- 
function file5_ynCk(cb) {
	for (j = 0; j < 2; j++) {
	if (eval("document.form1.file5_yn[" + j + "].checked") == true) {
		document.form1.file5_yn[j].checked = false;
	if (j == cb) {
		document.form1.file5_yn[j].checked = true;
         }
      }
   }
}
function file6_ynCk(cb) {
	for (j = 0; j < 2; j++) {
	if (eval("document.form1.file6_yn[" + j + "].checked") == true) {
		document.form1.file6_yn[j].checked = false;
	if (j == cb) {
		document.form1.file6_yn[j].checked = true;
         }
      }
   }
}
function file7_ynCk(cb) {
	for (j = 0; j < 2; j++) {
	if (eval("document.form1.file7_yn[" + j + "].checked") == true) {
		document.form1.file7_yn[j].checked = false;
	if (j == cb) {
		document.form1.file7_yn[j].checked = true;
         }
      }
   }
}
function file8_ynCk(cb) {
	for (j = 0; j < 2; j++) {
	if (eval("document.form1.file8_yn[" + j + "].checked") == true) {
		document.form1.file8_yn[j].checked = false;
	if (j == cb) {
		document.form1.file8_yn[j].checked = true;
         }
      }
   }
}
//-->
</script>
 

</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ����������� > <span class=style5>����÷�� ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="" name='form1' method='post' enctype="multipart/form-data">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
	<input type='hidden' name="s_height" value="<%=s_height%>">  
	<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 
	<input type='hidden' name="dept_id" value="<%=dept_id%>"> 
	<input type='hidden' name="sa_no" value="<%=id%>">
	<input type='hidden' name="gubun1" value="<%=gubun1%>">
	<input type='hidden' name="gubun2" value="<%=gubun2%>">
	<input type='hidden' name="user_nm" value="<%=user_nm%>">
	<tr>
		<td align='right'>
		        <%if(vt_size>0 && !END_DT.equals("")){%>
		        * Ȯ���� ���Դϴ�. ����� �� �����ϴ�.
		        <%}else{%>
			<a href="javascript:save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
			<%}%>
			<a href="javascript:free_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=40% class='title'>���</td>
                    <td colspan="2" align='left' >&nbsp;<%=user_nm%>
                    </td>
				</tr>
				<tr> 
                    <td class='title' width="40%">����⵵</td>
                    <td colspan="2">&nbsp; 
                        <%=s_year%>��
                        <input type='hidden' name="st_year" value="<%=s_year%>">                        
                    </td>
                </tr>
                <tr> 
                    <td class='title' width="40%">�ٷμҵ��� �ҵ�-���װ��� �Ű�</td>
                    <td colspan="2" >&nbsp; 
                      <input type="file" name="file_name1" size = "20">
					</td>
				</tr> 
				<tr> 
					<td class='title' width="40%">����û(PDF)����</td>
                    <td colspan="2" >&nbsp; 
					  <input type="file" name="file_name2" size = "20">
					</td>
				</tr> 
				<tr> 
					<td class='title' width="40%">��α�<br>(����û�ڷῡ �����Ե� ��α� ������)</td>
                    <td colspan="2" >&nbsp; 
					  <input type="file" name="file_name3" size = "20">&nbsp;<input type="checkbox" name="file3_yn" value='Y'>����
					</td>
				</tr> 
				<tr> 
					<td class='title' width="40%">��α� ���� ��Ÿ<br>(����û�ڷῡ �����Ե� ��� ��������)</td>
                    <td colspan="2" >&nbsp; 
					  <input type="file" name="file_name4" size = "20">&nbsp;<input type="checkbox" name="file4_yn" value='Y'>����
					</td>
				</tr> 
				<tr> 
					<td class='title' width="40%">�ֹε�ϵ</td>
                    <td colspan="2" >&nbsp; 
					  <input type="file" name="file_name5" size = "20">&nbsp;<input type="checkbox" name="file5_yn" value='Y' onClick="file5_ynCk(0)">���⵿��&nbsp;<input type="checkbox" name="file5_yn" value='N' onClick="file5_ynCk(1)">����
					</td>
				</tr> 
				<tr> 
					<td class='title' width="40%">������������(����)</td>
                    <td colspan="2" >&nbsp; 
					  <input type="file" name="file_name6" size = "20">&nbsp;<input type="checkbox" name="file6_yn" value='Y' onClick="file6_ynCk(0)">���⵿��&nbsp;<input type="checkbox" name="file6_yn" value='N' onClick="file6_ynCk(1)">����
					</td>
				</tr> 
				<tr> 
					<td class='title' width="40%">������������(�����)</td>
                    <td colspan="2" >&nbsp; 
					  <input type="file" name="file_name7" size = "20">&nbsp;<input type="checkbox" name="file7_yn" value='Y' onClick="file7_ynCk(0)">���⵿��&nbsp;<input type="checkbox" name="file7_yn" value='N' onClick="file7_ynCk(1)">����
					</td>
				</tr> 
				<tr> 
					<td class='title' width="40%">�����(�ź����纻��)</td>
                    <td colspan="2" >&nbsp; 
					  <input type="file" name="file_name8" size = "20">&nbsp;<input type="checkbox" name="file8_yn" value='Y' onClick="file8_ynCk(0)">���⵿��&nbsp;<input type="checkbox" name="file8_yn" value='N' onClick="file8_ynCk(1)">����
                    </td>
                </tr>
				<tr> 
					<td class='title' width="40%">��������</td>
                    <td colspan="2" >&nbsp; 
					  <select name="change_his">
						<option value="1">���⵿��</option>
						<option value="2">�߰�</option>
						<option value="3">����</option>
					  </select>
                    </td>
                </tr>
            </table>
			 	
			
		</td>
	</tr>	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
