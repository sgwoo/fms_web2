<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	//���·Ḯ��Ʈ
	Vector FineList = FineDocDb.getFineDocLists(doc_id);
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "fine1");//���μ���
	String var2 = e_db.getEstiSikVarCase("1", "", "fine2");	//�����	
	String var3 = e_db.getEstiSikVarCase("1", "", "fine_app1");//÷�μ���1
	String var4 = e_db.getEstiSikVarCase("1", "", "fine_app2");//÷�μ���2
	String var5 = e_db.getEstiSikVarCase("1", "", "fine_app3");//÷�μ���3
	String var6 = e_db.getEstiSikVarCase("1", "", "fine_app4");//÷�μ���4
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//���·� ���ű�� �˻��ϱ�
	function fine_gov_search(){
		var fm = document.form1;	
		window.open("../fine_doc_reg/fine_gov_search.jsp?t_wd="+fm.gov_nm.value, "SEARCH_FINE_GOV", "left=200, top=200, width=550, height=450, resizable=yes, scrollbars=yes, status=yes");
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') fine_gov_search();
	}	
	
	//���·�˻��ϱ�
	function fine_search(){
		var fm = document.form1;
		window.open("fine_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>", "SEARCH_FINE", "left=200, top=200, width=750, height=450, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//���ű�� ���� 
	function view_fine_gov(gov_id){
		window.open("../fine_doc_reg/fine_gov_c.jsp?gov_id="+gov_id, "view_FINE_GOV", "left=200, top=200, width=560, height=150, resizable=yes, scrollbars=yes, status=yes");
	}

	//��Ϻ���
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "fine_doc_mng_frame.jsp";
		fm.submit();
	}			
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//�����ϱ�
	function fine_doc_upd(){	
		var fm = document.form1;
		
		if(fm.doc_id.value == '')		{ alert('������ȣ�� Ȯ���Ͻʽÿ�.'); return; }
		if(fm.doc_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }		
		if(fm.gov_id.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); return; }		
		if(fm.gov_nm.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); return; }

		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = "fine_doc_u_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}		
		
/*
	//���
	function reg_forfeit(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "./fine_doc_mng_frame.jsp";
		fm.submit();
	}
	
	//���ݰ��� �̵�
	function forfeit_in(){
		var fm = document.form1;
		fm.gubun2.value = '6';
		fm.target = "d_content";
		fm.action = "/acar/con_forfeit/forfeit_frame_s.jsp";
		fm.submit();
	}	
	//����ϱ�
	function fine_gov(gov_id){
		window.open("fine_gov_info.jsp?gov_id="+gov_id, "REG_FINE_GOV", "left=200, top=200, width=550, height=150, resizable=yes, scrollbars=yes, status=yes");
	}
*/	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='h_mng_id' value='<%=FineDocBn.getH_mng_id()%>'>
<input type='hidden' name='b_mng_id' value='<%=FineDocBn.getB_mng_id()%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > <span class=style5>���ǽ�û���� ����</span></span></td>
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
        <td class="line" colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=12%>������ȣ</td>
                    <td width=88%>&nbsp;<%=FineDocBn.getDoc_id()%></td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;<input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                      &nbsp;<input type="text" name="gov_nm" value='<%=FineGovBn.getGov_nm()%>' size="50" class="text" style='IME-MODE: active' onKeyDown='javascript:enter()'>
        			  <input type='hidden' name="gov_id" value='<%=FineGovBn.getGov_id()%>'>
                      <a href="javascript:fine_gov_search();"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
    			    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;<input type="text" name="mng_dept" value='<%=FineDocBn.getMng_dept()%>' size="50" class="text">
        			              (����ڸ� : 
                      <input name="mng_nm" type="text" value='<%=FineDocBn.getMng_nm()%>' class="text" size="10">
                      / ��������� : 
                      <input name="mng_pos" type="text" value='<%=FineDocBn.getMng_pos()%>' class="text" size="10">
                      )</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;���α�������� ���·� �ΰ� ó�п� ���� �ǰ� ���� (���·� �����ǹ��� ���� ��û)</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;�� 
                    <input name="gov_st" type="text" value='<%=FineDocBn.getGov_st()%>' class="text" size="10">
                    �� ������ ������ ����մϴ�. </td>
                </tr>		  
                <tr> 
                    <td class='title'>÷��</td>
                    <td>
        			<input type="checkbox" name="app_doc1" value="Y" <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var3%><br>
        			<input type="checkbox" name="app_doc2" value="Y" <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var4%><br>
        			<input type="checkbox" name="app_doc3" value="Y" <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var5%><br>
        			<input type="checkbox" name="app_doc4" value="Y" <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var6%>
                    </td>
                </tr>		
                <tr> 
                    <td class='title'>����ȣ</td>
                    <td>&nbsp;<input type="text" name="post_num" value='<%=FineDocBn.getPost_num()%>' class="text" size="30">
                </tr>	  		  
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right">
	    <%if(FineDocBn.getPrint_dt().equals("")){%>
	    <%}else{%>
	    <img src=/acar/images/center/arrow_printd.gif> : <%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%>&nbsp;&nbsp;&nbsp;
	    <%}%>
	    <a href="javascript:fine_doc_upd();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	    &nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>	  
	    </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
