<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
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
		window.open("../fine_doc_reg/fine_gov_search.jsp?t_wd="+fm.gov_nm.value, "SEARCH_FINE_GOV", "left=200, top=200, width=550, height=450, scrollbars=yes");
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') fine_gov_search();
	}	
	
	//���·�˻��ϱ�
	function fine_search(){
		var fm = document.form1;
		window.open("fine_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>", "SEARCH_FINE", "left=200, top=200, width=750, height=450, scrollbars=yes");
	}	
	
	//���ű�� ���� 
	function view_fine_gov(gov_id){
		window.open("../fine_doc_reg/fine_gov_c.jsp?gov_id="+gov_id, "view_FINE_GOV", "left=200, top=200, width=560, height=150, scrollbars=yes");
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
		window.open("fine_gov_info.jsp?gov_id="+gov_id, "REG_FINE_GOV", "left=200, top=200, width=550, height=150, scrollbars=yes");
	}
*/	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
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
  <table border="0" cellspacing="0" cellpadding="0" width=820>
    <tr> 
      <td><font color="navy">������ -> </font><font color="red">���ǽ�û���� ����</font></td>
      <td align="right"><!--<a href="javascript:go_list();" onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a>--></td>
      <td align="right" width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td class="line" colspan="2" width="800"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="80">������ȣ</td>
            <td><%=FineDocBn.getDoc_id()%></td>
          </tr>
          <tr> 
            <td class='title' width="80">��������</td>
            <td><input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>
          <tr> 
            <td class='title' width="80">����</td>
            <td>
              <input type="text" name="gov_nm" value='<%=FineGovBn.getGov_nm()%>' size="50" class="text" style='IME-MODE: active' onKeyDown='javascript:enter()'>
			  <input type='hidden' name="gov_id" value='<%=FineGovBn.getGov_id()%>'>
              <a href="javascript:fine_gov_search();" onMouseOver="window.status=''; return true">�˻�</a>
			</td>
          </tr>
          <tr> 
            <td class='title' width="80">����</td>
            <td><input type="text" name="mng_dept" value='<%=FineDocBn.getMng_dept()%>' size="50" class="text">
			              (����ڸ� : 
              <input name="mng_nm" type="text" value='<%=FineDocBn.getMng_nm()%>' class="text" size="10">
              / ��������� : 
              <input name="mng_pos" type="text" value='<%=FineDocBn.getMng_pos()%>' class="text" size="10">
              )</td>
          </tr>
          <tr> 
            <td class='title' width="80">����</td>
            <td> ���α�������� ���·� �ΰ� ó�п� ���� �ǰ� ���� (���·� �����ǹ��� ���� ��û)</td>
          </tr>
          <tr> 
            <td class='title' width="80">����</td>
            <td> �� 
            <input name="gov_st" type="text" value='<%=FineDocBn.getGov_st()%>' class="text" size="10">
            �� ������ ������ ����մϴ�. </td>
          </tr>		  
          <tr> 
            <td class='title' width="80">÷��</td>
            <td>
			<input type="checkbox" name="app_doc1" value="Y" <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var3%><br>
			<input type="checkbox" name="app_doc2" value="Y" <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var4%><br>
			<input type="checkbox" name="app_doc3" value="Y" <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var5%><br>
			<input type="checkbox" name="app_doc4" value="Y" <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var6%>
            </td>
          </tr>		  		  
        </table>
      </td>
      <td width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td height="21">&nbsp;</td>
      <td align="right" height="21">
	  <%if(FineDocBn.getPrint_dt().equals("")){%>
	  <%}else{%>
	  �μ����� : <%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%>&nbsp;&nbsp;
	  <%}%>
	  <a href="javascript:fine_doc_upd();" onMouseOver="window.status=''; return true"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
	  &nbsp;<a href="javascript:window.close()"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a>	  
	  </td>
      <td height="21">&nbsp;</td>
    </tr>
	<!--
    <tr> 
      <td height="21">&lt;���·Ḯ��Ʈ&gt;</td>
      <td align="right" height="21">&nbsp;</td>
      <td height="21">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="30" rowspan="2">����</td>
            <td width='180' class='title' rowspan="2">��������ȣ</td>
            <td width='100' class='title' rowspan="2">������ȣ</td>
            <td colspan="4" class='title'>������</td>
            <td width='60' class='title' rowspan="2">ó��</td>
          </tr>
          <tr> 
            <td width='150' class='title'>��ȣ/����</td>
            <td width='100' class='title'>�ֹε�Ϲ�ȣ</td>
            <td width='100' class='title'>����ڵ�Ϲ�ȣ</td>
            <td width='80' class='title'>�Ӵ�Ⱓ</td>
          </tr>-->
          <% if(FineList.size()>0){
				for(int i=0; i<1; i++){ 
					FineDocListBn = (FineDocListBean)FineList.elementAt(i); %>		  
<!--          <tr align="center"> 
            <td><%=i+1%></td>
            <td><a class=index1 href="javascript:MM_openBrWindow('../fine_doc_reg/fine_c.jsp?m_id=<%=FineDocListBn.getRent_mng_id()%>&l_cd=<%=FineDocListBn.getRent_l_cd()%>&c_id=<%=FineDocListBn.getCar_mng_id()%>&seq_no=<%=FineDocListBn.getSeq_no()%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=450,left=100, top=100')"><%=FineDocListBn.getPaid_no()%></a></td>			
            <td><%=FineDocListBn.getCar_no()%></td>
            <td><%=FineDocListBn.getFirm_nm()%></td>
            <td><%=AddUtil.ChangeSsn(FineDocListBn.getSsn())%></td>
            <td><%=AddUtil.ChangeEnt_no(FineDocListBn.getEnp_no())%></td>
            <td><%=FineDocListBn.getRent_start_dt()%>~<br>
              <%=FineDocListBn.getRent_end_dt()%></td>
            <td>
			<a href="#">U</a> | <a href="#">D</a>				
			</td>
          </tr>-->
          <% 	}
			} %>
<!--			
          <tr align="center"> 
            <td><a href="javascript:fine_search();" onMouseOver="window.status=''; return true">�߰�</a>
			<input type='hidden' name='car_mng_id' value=''>
			<input type='hidden' name='seq_no' value=''>
			<input type='hidden' name='rent_mng_id' value=''>
			<input type='hidden' name='rent_l_cd' value=''>			
			<input type='hidden' name='rent_s_cd' value=''></td>
            <td><input type="text" name="paid_no" size="25" class="text" value="">			
			</td>
            <td><input type="text" name="car_no" size="12" class="text" value=""></td>
            <td>
			<input type="text" name="firm_nm" size="20" class="text" value="">
			<input type='hidden' name='client_id' value=''>
			</td>
            <td><input type="text" name="ssn" size="13" class="text" value=""></td>
            <td><input type="text" name="enp_no" size="13" class="text" value=""></td>
            <td><input type="text" name="rent_start_dt" size="9" class="text" value="">~<br>
			    <input type="text" name="rent_end_dt" size="9" class="text" value=""></td>
            <td><a href="#">���</a></td>
          </tr>		-->	
        </table>
      </td>
      <td>&nbsp;</td>	  
    </tr>
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
