<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.client.*, acar.fee.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//�ŷ�ó
	ClientBean client = al_db.getClient(client_id);
	DeptBean dept_r [] = umd.getDeptAll();
	
	
	
	Hashtable fee_base = af_db.getFeebasecls2(m_id, l_cd);
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	
	function Search(arg){
		var fm = document.form1;
		var l_cd = "";
		var firm_nm = "";
		var gov_nm = "";
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			if(arg=="firm_nm"){
				firm_nm = fm.firm_nm.value;
				var SUBWIN="client_search.jsp?t_wd="+fm.firm_nm.value;	
				window.open(SUBWIN, "firm_nm", "left=100, top=100, width=1020, height=500, scrollbars=yes");
			}else if(arg=="gov_nm"){

				fine_gov_search();
			}
		}
	}
		
	//���
	function doc_reg(){
		var fm = document.form1;
		
		if(fm.doc_id.value == '')		{ alert('��Ұ�� �Ǵ� �Ҽ��� �����Ͻʽÿ�.'); 	return; }
		if(fm.doc_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.'); 	return; }		
		if(fm.gov_id.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); 	return; }		
		if(fm.firm_nm.value == '')		{ alert('��ȣ�� �����Ͻʽÿ�.'); 	return; }
		if(fm.title.value == '')		{ alert('������ �Է��Ͻʽÿ�.'); 		return; }
	//	if(fm.filename2.value == '')	{ alert('��ĵ�� ÷���Ͻʽÿ�.'); 		return; }		
		
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}		
		fm.action = "rece_c_7_reg_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
	}
	
	
	
		//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			
	
	
	//���·�û����� �˻��ϱ�
	function fine_gov_search(){
		var fm = document.form1;	
		window.open("/acar/fine_doc_reg/fine_gov_search.jsp?t_wd="+fm.gov_nm.value, "SEARCH_FINE_GOV", "left=200, top=200, width=550, height=450, scrollbars=yes");
	}
	
	//�˾������� ����
	function SearchopenBrWindow() { //v2.0
		var fm = document.form1;
		window.open("client_search.jsp?t_wd="+fm.firm_nm.value, "search_open", "left=50, top=50, width=800, height=500, scrollbars=yes");
	}
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post' enctype="multipart/form-data">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > ���������Ȳ > <span class=style5>���/����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
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
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width=12%>�����</td>
            <td>&nbsp;&nbsp;<input type="text" name="rece7_dt" size="20" class="text" value=""></td>
          </tr>
		  
		  <tr> 
            <td class='title'>��������</td>
            <td>&nbsp;&nbsp;<input type="text" name="rece7_gubun" value="" size="50" class="text"></td>
          </tr>
          <tr> 
            <td class='title'>��������</td>
            <td>&nbsp;&nbsp;<input type="text" name="rece7_job" value="" size="50" class="text" ></td>
          </tr>
		  <tr> 
            <td class='title'>����ó</td>
            <td>&nbsp; <input type="text" name="rece7_off" size="40" class="text" value=""></td>
          </tr>
		  <tr> 
            <td class='title'>�����</td>
            <td>&nbsp;&nbsp;<input type="text" name="rece7_mngid" size="11" class="text" value="" ></td>
          </tr>
          <tr> 
            <td class='title'>������</td>
            <td>&nbsp;&nbsp;<input type="text" name="rece7_amt" size="11" class="text" value="" class=num ></td>
          </tr>
          <tr> 
            <td class='title'>��ĵ</td>
            <td>&nbsp;&nbsp;<input type="file" name="filename2" size="40"></td>
          </tr>
		  <tr> 
            <td class='title'>����</td>
            <td>&nbsp;&nbsp;<textarea name="rece7_note" cols="70" rows=3 class="text" value="" class= ></textarea></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tr>
		
    <tr>
      <td align="right">
	  <%//if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	  <a href='javascript:doc_reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
	  <%//}%>
	  </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
