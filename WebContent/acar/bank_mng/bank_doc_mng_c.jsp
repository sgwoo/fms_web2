<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*,  acar.user_mng.*, acar.estimate_mng.*"%>
<%@ page import="acar.partner.*" %>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "07");	
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
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
	String s_cpt = request.getParameter("s_cpt")==null?"":request.getParameter("s_cpt");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String bank_id = "";
	String bank_nm = "";
	String fund_yn = "";
	
	String cmd = "";
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	Serv_EmpDatabase se_db = Serv_EmpDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);

	//�����û ����Ʈ
	Vector FineList = FineDocDb.getBankDocListsH(doc_id);
		
	Vector PFineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "HEAD", "Y");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "bank1");//���μ���
	String var2 = e_db.getEstiSikVarCase("1", "", "bank2");	//�����	
	String var3 = e_db.getEstiSikVarCase("1", "", "bank_app1");//÷�μ���1
	String var4 = e_db.getEstiSikVarCase("1", "", "bank_app2");//÷�μ���2
	String var5 = e_db.getEstiSikVarCase("1", "", "bank_app3");//÷�μ���3
	String var6 = e_db.getEstiSikVarCase("1", "", "bank_app4");//÷�μ���4
	String var7 ="";
	
	 if  (Integer.parseInt(FineDocBn.getDoc_dt()) > 20141204) {	
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app6");//÷�μ���5
	 } else {
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app5");//÷�μ���5
	} 
	
	long amt_tot =0;
	long amt_tot2 = 0; //�����ݾ� �հ�
	long amt_tot3 = 0; //���԰��� �հ�
	int car_su = 0; //�������
	double amt1_tot = 0; //��ϼ�
	double amt2_tot = 0; //������
	
	long loan_amt1 = 0;
	long loan_amt2 = 0;
	
			
	//���� �����
	Vector vt = se_db.getServ_empList("", Integer.toString(FineDocBn.getSeq()), "1", "", FineDocBn.getOff_id(), "all");
	int vt_size = vt.size();	
		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function sms_send(emp_nm, mtel){
		var SUBWIN="/acar/sms_gate/sms_mini_gate.jsp?auth_rw=<%= auth_rw %>&destname="+emp_nm+"&destphone="+mtel;
		window.open(SUBWIN, "sms_send", "left=100, top=120, width=500, height=400, scrollbars=no");
	}

	//���⳻�� ��༭ ���
	function ObjectionPrintAll(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print_all.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//���⳻�� ��༭ ���(�׽�Ʈ)
	function ObjectionPrintAllTest(){
		var fm = document.form1;
		var SUMWIN = "";
		var doc_id = encodeURIComponent('<%=doc_id%>',"EUC-KR");
		var chk = document.getElementsByName("chk")[0].value;
		SUMWIN="https://fms3.amazoncar.co.kr/acar/mng_pdf/objection_print_all2.jsp?doc_id="+doc_id+"&chk="+chk;	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	
	//���⳻�� ��������� ���
	function ObjectionPrintAll2(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print_reg_all.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	//���⳻�� ���ݰ�꼭 ���
	function ObjectionPrintAll3(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print_tax_all.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//���⳻���� ���
	function ObjectionPrint(){
		var fm = document.form1;
		var SUMWIN = "";
		if( fm.bank_id.value =="0026"  ){
			SUMWIN="objection_print1.jsp?doc_id=<%=doc_id%>";	
		} else if( fm.bank_id.value =="0083"  ){
				SUMWIN="objection_print4.jsp?doc_id=<%=doc_id%>";		
		} else {
			SUMWIN="objection_print.jsp?doc_id=<%=doc_id%>";	
		}	
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
		//���⳻���� excel��� - ����ĳ��Ż ����߻�ó���� Ư�̳���ó�� (20220617)
	function ToExcel(){
		var fm = document.form1;
		var SUMWIN = "";
		
		if( fm.bank_id.value =="0026" ){
			SUMWIN="objection_excel_print1.jsp?doc_id=<%=doc_id%>";	
		} else if( fm.bank_id.value =="0083"  ){
			SUMWIN="objection_excel_print4.jsp?doc_id=<%=doc_id%>";		
		} else if( fm.bank_id.value =="0011" & fm.card_yn.value =="Y" ){
			SUMWIN="objection_excel_print5.jsp?doc_id=<%=doc_id%>";			
		} else {
			SUMWIN="objection_excel_print.jsp?doc_id=<%=doc_id%>";	
		}
				
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
		//��༭���
	function ToExcel1(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_excel1_print.jsp?doc_id=<%=doc_id%>";	
		
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//���������
	function jPrint(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "j", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//�絵���������
	function j1Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j_1.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "j", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//ä�Ǿ絵�������������
	function j20121203Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j20121203.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "j20121203", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//ä�Ǿ絵 ���������
	function j120121203Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j_120121203.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "j_120121203", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//����ϱ�
	function FineDocPrint(){
		var fm = document.form1;
		var SUMWIN = "";
			
		if(fm.bank_id.value =="0026" || fm.bank_id.value =="0037"  || fm.bank_id.value =="0033"   || fm.bank_id.value =="0029"  || fm.bank_id.value =="0025"   ){
			SUMWIN="bank_doc_print1.jsp?doc_id=<%=doc_id%>";	
		}else{
			SUMWIN="bank_doc_print.jsp?doc_id=<%=doc_id%>";	
		}
		
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	
	//������ȣ ���
	function j2Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j_2.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=1000, height=800, scrollbars=yes, status=yes");			
	}
	
	//�����㺸 ��� ���
	function ObjectionPrint10(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print10.jsp?doc_id=<%=doc_id%>";	 
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=750, height=804, scrollbars=yes, status=yes");		
	}
	
	//��Ϻ���
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "bank_doc_mng_frame.jsp";
		fm.submit();
	}			
	//�����ϱ�
	function fine_update(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "bank_doc_mng_u.jsp";
		fm.submit();
	}	
	
		//�����ϱ�
	function fine_del(){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.target = "d_content";
		fm.action = "bank_doc_mng_d_a.jsp";
		fm.submit();
	}
	
	
	//�����ϱ�
	function fine_upd(){
		window.open("bank_doc_mng_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=860, height=600, scrollbars=yes");
	}

	function updatelist(){
		var fm = document.form1;	
		var bank_id = <%=FineDocBn.getGov_id()%>;
		window.open("bank_doc_list_u.jsp?fund_yn=<%=FineDocBn.getFund_yn()%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&doc_id=<%=doc_id%>&bank_id=<%=FineDocBn.getGov_id()%>&bank_nm=<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%>", "CHANGE_ITEM", "left= 50, top=50, width=1100, height=800, scrollbars=yes");
	
	}	
	
	function Regynyn(doc_id){
	var fm = document.form1;
	fm.cmd.value = "y";
	fm.action = "bank_doc_mng_u_a.jsp?doc_id="+doc_id;	
	fm.target = "i_no";
	fm.submit();
	}
	
	function Regcltr_chk(doc_id){
	var fm = document.form1;
	fm.cmd.value = "cltr_chk";
	fm.action = "bank_doc_mng_u_a.jsp?doc_id="+doc_id;	
	fm.target = "i_no";
	fm.submit();
	}
	
	
	function bank_massges_reg(){
		var fm = document.form1;
		if(!confirm('��޽����� �޼����� �����ðڽ��ϱ�?')){	return;	}
		fm.cmd.value = "m";
		fm.target = "d_content";
		fm.action = "bank_doc_reg_sc_a.jsp";
		fm.submit();
	}
	
	
	//����ǥ ���
	function ObjectionPrint2(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print2_excel.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//���ฮ��Ʈ ���
	function ObjectionPrint3(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print3_excel.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//���������μ�
	function ObjectionPrintalldiv(){
	
		var fm = document.form1;
		
		var start_num 	= 0;
		var end_num 	= 0;
	
		
		if(fm.doc_print_st.value == '' && toInt(fm.d_start_num.value) >0){
			start_num 	= toInt(fm.d_start_num.value);
			end_num 	= toInt(fm.d_end_num.value);			
		}else{ 
			if(fm.doc_print_st.value == ''){ alert('�����μ� ������ �����Ͻʽÿ�.'); return; }
			var select_nums = fm.doc_print_st.value.split("~");				
			start_num 	= toInt(select_nums[0]);
			end_num 	= toInt(select_nums[1]);			
		}		
		
		//alert(fm.doc_print_st.value);
		
		fm.start_num.value 	= start_num;
		fm.end_num.value 	= end_num;		
		fm.target = "_blank";
		
		fm.action = "objection_print_all_div.jsp";		
		fm.submit();	
		
	}
	
	
//-->
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
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
<input type='hidden' name='s_cpt' value='<%=s_cpt%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='bank_id' value='<%=FineDocBn.getGov_id()%>'>
<input type='hidden' name='fund_yn' value='<%=FineDocBn.getFund_yn()%>'>
<input type='hidden' name='bank_nm' value='<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%>'>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='start_num' value=''>
<input type='hidden' name='end_num' value=''>
<input type='hidden' name='card_yn' value='<%=FineDocBn.getCard_yn()%>'> 

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > �����ڱݰ��� > <span class=style5>������� ��û��������</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td align="right">
        <% if (nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("�������������",user_id)   || nm_db.getWorkAuthUser("���������",user_id)   || nm_db.getWorkAuthUser("CMS����",user_id) ||  nm_db.getWorkAuthUser("��ݴ��",user_id)    ){%>
        <a href="javascript:fine_del();"><img src=../images/center/button_delete.gif align=absmiddle border=0></a>&nbsp;
	    <a href="javascript:fine_upd();"><img src=../images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
	    <% } %>
	    <a href="javascript:go_list();"><img src=../images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=15%>������ȣ</td>
                    <td width=85%>&nbsp;&nbsp;<%=FineDocBn.getDoc_id()%></td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;&nbsp;<%=AddUtil.getDate3(FineDocBn.getDoc_dt())%>
                    <%if(FineDocBn.getFund_yn().equals("Y")) {%>&nbsp;&nbsp;&nbsp;&nbsp;[�ڱ�]&nbsp;����<%} %>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;&nbsp;<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;&nbsp;<%=FineDocBn.getMng_dept()%></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;&nbsp;<%=FineDocBn.getTitle()%></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td style='height:36'>&nbsp;&nbsp;1. �� ���� ������ ������ ����մϴ�. <br>
                	   &nbsp;&nbsp;2. �Ʒ��� ���� �ڵ��� ���Կ� �ʿ��� �ڱ��� ��û�Ͽ���, ���� �� �����Ͽ� �ֽʽÿ�.
                
                    </td>
                </tr>		  
                <tr> 
                    <td class='title'>÷��</td>
                    <td>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc1" value="Y" disabled <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var3%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc2" value="Y" disabled <%if(FineDocBn.getApp_doc2().equals("Y"))%>checked<%%>><%=var4%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc3" value="Y" disabled <%if(FineDocBn.getApp_doc3().equals("Y"))%>checked<%%>><%=var5%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc4" value="Y" disabled <%if(FineDocBn.getApp_doc4().equals("Y"))%>checked<%%>><%=var6%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc5" value="Y" disabled <%if(FineDocBn.getApp_doc5().equals("Y"))%>checked<%%>><%=var7%>
        			</td>
                </tr>	
                <tr> 
                    <td class='title'>�����缳��</td>
                   <td ><font color=red>&nbsp; ������� 
                      <%=FineDocBn.getCltr_rat()%>
                      (%)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�Ǵ� �����Ǵ� <%=FineDocBn.getCltr_amt()%>��</font> &nbsp;&nbsp; <font color=blue>*!!!!!�ݵ�� �Ǳ����缳������ ���غ�����!!!!</font>
                    </td>
                </tr>
                
                <% if ( FineDocBn.getCard_yn().equals("Y")){ %>                
                <tr> 
                    <td class='title'>ī���Һ� ��������</td>
                   <td>&nbsp;&nbsp<%=AddUtil.getDate3(FineDocBn.getApp_dt())%>&nbsp;&nbsp;              
                   </td>
                </tr>	  	  
                <% } %>
                  <tr> 
                    <td class='title'>CMS����ڵ�</td>
                   <td>&nbsp;&nbsp<%=FineDocBn.getCms_code()%>&nbsp;&nbsp; *����ǿ��� ����մϴ�.             
                   </td>
                </tr>	  	
                	  		  
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
      
	<%if(!FineDocBn.getReq_dt().equals("")){%>
	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ǽ������ �Ա�Ȯ��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td class='title' width="25%">��ϼ�</td>
					<td class='title' width="25%">������</td>
					<td class='title' width="25%">�߽�����</td>
					<td class='title' width="25%">ȯ������</td>
				</tr>
				<tr>
					<td class='' align="right"><%=Util.parseDecimal(FineDocBn.getAmt1())%>��&nbsp;</td>
					<td class='' align="right"><%=Util.parseDecimal(FineDocBn.getAmt2())%>��&nbsp;</td>
					<td class='' align="center"><%=AddUtil.getDate3(FineDocBn.getReq_dt())%></td>
					<td class='' align="center"><%=AddUtil.getDate3(FineDocBn.getIp_dt())%></td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<%}%>
	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=15% class='title'>���μ���</td>
                    <td width=30%>&nbsp;&nbsp;<select name='h_mng_id' disabled>
                        <option value="">����</option>
                        <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getH_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                      </select></td>
                    <td width=15% class='title'>�����</td>
                    <td width=40%>&nbsp;&nbsp;<select name='b_mng_id' disabled>
                        <option value="">����</option>
                        <%	if(user_size2 > 0){
            						for (int i = 0 ; i < user_size2 ; i++){
            							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getB_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                      </select></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right" colspan=2>
        	  <%if(FineDocBn.getPrint_dt().equals("")){%>
        	  <a href="javascript:FineDocPrint();"><img src=../images/center/button_print_gm.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        	  <%}else{%>
        	  <img src=../images/center/arrow_printd.gif align=absmiddle> : <a href="javascript:FineDocPrint();"><%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%> (<%=c_db.getNameById(FineDocBn.getPrint_id(), "USER")%>)</a>&nbsp;&nbsp;
        	  <%}%>	  
				<a href="javascript:ObjectionPrintAll();"><img src=../images/center/button_print_gys.gif align=absmiddle border=0></a>&nbsp;
				<a href="javascript:ObjectionPrintAll2();">�����</a>&nbsp;
				<a href="javascript:ObjectionPrintAll3();">���ݰ�꼭</a>&nbsp;
				<a href="javascript:ToExcel1();">��༭����</a> 
				<a href="javascript:ObjectionPrint();"><img src=../images/center/button_dcnys.gif align=absmiddle border=0></a>&nbsp;
				[<a href="javascript:j20121203Print();">ä�Ǿ絵����������</a>]
				[<a href="javascript:j120121203Print();">ä�Ǿ絵������</a>]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<!--<a href="javascript:jPrint();"><img src=../images/center/button_wij.gif align=absmiddle border=0></a>&nbsp;
				<a href="javascript:j1Print();"><img src=../images/center/button_ydtjs.gif align=absmiddle border=0></a>&nbsp;-->
				[<a href="javascript:ObjectionPrint10();">�����㺸</a>]&nbsp; 
				<a href="javascript:j2Print();"><img src=../images/center/button_num_car.gif align=absmiddle border=0></a>&nbsp; 
				<a href="javascript:ToExcel();"><img src=../images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;  
				[<a href="javascript:ObjectionPrint2();">����ǥ</a>]&nbsp;  
				[<a href="javascript:ObjectionPrint3();">���ฮ��Ʈ</a>]
				
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����û����Ʈ&nbsp;<a href="javascript:updatelist()"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a></span>
		
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span class=style2><select name='chk' id="chk">
                        <option value="1">��༭</option> 
                        <option value="2">���ݰ�꼭</option> 
                        <option value="3">�ڵ��������</option>  
                        <option value="4">�Ÿ��ֹ���</option> �����μ� : 
                    </select>    
		<select name='doc_print_st'> 
		  <option value="">����</option>
		<%	int max_num = 30;
			for(int i=0; i<PFineList.size(); i+=max_num){
				int start_num 	= i+1;
				int end_num 	= i+max_num;
				if(end_num>PFineList.size()) end_num = PFineList.size();  %>
		  <option value="<%=start_num%>~<%=end_num%>"><%=start_num%>~<%=end_num%></option>
		<%	}%>	
		</select>
		&nbsp;	
		��Ÿ���� : 
		<input type="text" name="d_start_num" size="2" class="text" value="">~<input type="text" name="d_end_num" size="2" class="text" value="">
		&nbsp;
		<a href="javascript:ObjectionPrintalldiv();"><img src="/acar/images/center/button_print_all.gif" align="absmiddle" border="0"></a></span>
		&nbsp;&nbsp;<a href="javascript:ObjectionPrintAllTest();">PDF�� ���</a>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				
		
		<img src=../images/center/icon_arrow.gif align=absmiddle><span class=style2>����� ��������</span> &nbsp;
			<select name="yn">
				<option value="" <%if(FineDocBn.getRegyn().equals(""))%>selected<%%>>����</option>
				<option value="Y" <%if(FineDocBn.getRegyn().equals("Y"))%>selected<%%>>�Ϸ�</option>
				<option value="N" <%if(FineDocBn.getRegyn().equals("N"))%>selected<%%>>�̺�</option>
			</select>&nbsp;
			   <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
			<a href="javascript:Regynyn('<%=doc_id%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
			<% } %>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<img src=../images/center/icon_arrow.gif align=absmiddle><span class=style2>�㺸����</span> &nbsp;
				<select name="cltr_chk">
					<option value="" <%if(FineDocBn.getCltr_chk().equals(""))%>selected<%%>>����</option>
					<option value="1" <%if(FineDocBn.getCltr_chk().equals("1"))%>selected<%%>>����</option>
					<option value="2" <%if(FineDocBn.getCltr_chk().equals("2"))%>selected<%%>>����</option>
				</select>&nbsp;
				  <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
							<a href="javascript:Regcltr_chk('<%=doc_id%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
				  <% } %>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="20%" colspan="2">��ȯ����</td>
                    <td class='title' rowspan="2" width="10%">���Դ��</td>
                    <td class='title' rowspan="2" width="15%">���԰���</td>
                    <td class='title' colspan="2" width="30%">����</td>
                    <td class='title' rowspan="2" width="15%">�����ݾ�</td>
                    <td class='title' rowspan="2" width="10%">����ݸ�</td>
                </tr>
                <tr> 
                    <td class='title' width="10%" height="25" align="center" >�Ⱓ</td>
                    <td class='title' width="10%" align="center" >���</td>
                    <td class='title' width="15%" align="center" >�ݾ�</td>
                    <td class='title' width="15%" align="center" >��������</td>
                </tr>
                  <% if(FineList.size()>0){
        				for(int i=0; i<FineList.size(); i++){ 
        					Hashtable ht1 = (Hashtable)FineList.elementAt(i);
        					        				
        						amt_tot   += AddUtil.parseLong(String.valueOf(ht1.get("AMT3")));
        						amt_tot2  += AddUtil.parseLong(String.valueOf(ht1.get("AMT6")));
        						amt_tot3  += AddUtil.parseLong(String.valueOf(ht1.get("AMT2")));			
							        					
							 	car_su += AddUtil.parseLong(String.valueOf(ht1.get("AMT1")));
        		 %>					
                <tr align="center"> 
                    <td><%=ht1.get("PAID_NO")%>����</td>			
                    <td><%=ht1.get("CAR_ST")%></td>
                    <td><%=ht1.get("AMT1")%></td>
                    <td align="right"><%=Util.parseDecimalLong(String.valueOf(ht1.get("AMT2")))%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimalLong(String.valueOf(ht1.get("AMT3")))%>&nbsp;</td>
                    <td><%=ht1.get("VIO_DT")%></td>
                    <td align="right"><%=Util.parseDecimalLong(String.valueOf(ht1.get("AMT6")))%>&nbsp;
<!--
<% if (    FineDocBn.getGov_id().equals("0044")  ||  FineDocBn.getGov_id().equals("0059")  ) { %>
 	<%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt3()  ))%>&nbsp;
<% } else if (    FineDocBn.getGov_id().equals("0018") ) { %>
 	<%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt4()  ))%>&nbsp; 	
 <% } else if (    FineDocBn.getGov_id().equals("0058") ) { %>
 	<%=Util.parseDecimal(String.valueOf((1000000 *FineDocListBn.getAmt1()) ))%>&nbsp; 		
<% } else { %>      
            <%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt3() / 2 ))%>&nbsp;
<% } %> -->                   
                    </td>
                    <td><%=ht1.get("SCAN_FILE")%></td>
                </tr>
				<input type='hidden' name='vio_dt' value='<%=ht1.get("VIO_DT")%>'>
                  <% 	}
				  
					amt1_tot = amt_tot2 * 0.002;
					amt2_tot = amt_tot2 * 0.004;
				  
				  	loan_amt1 = (long) amt1_tot;
					loan_amt1 = AddUtil.l_th_rnd_long(loan_amt1);
					loan_amt2 = (long)  amt2_tot;
					loan_amt2 = AddUtil.l_th_rnd_long(loan_amt2);
					
        			} %>
				<tr>
					<td class='title' colspan='2'> ����ݾ� �հ�</td>
					<td align='center'><%=Util.parseDecimal(car_su)%> </td>
					<td align='right'><%=Util.parseDecimalLong(amt_tot3)%>��&nbsp; </td>
					<td align='right'><%=Util.parseDecimalLong(amt_tot)%>��&nbsp; </td>
					<input type='hidden' name='amt_tot' value='<%=Util.parseDecimalLong(amt_tot)%>'>	
					<td align='right' class='title'>�����ݾ� �հ�</td>
					<td align='right'><%=Util.parseDecimalLong(amt_tot2)%>��&nbsp; </td>
					<td align='right' class='title'></td>
				</tr>
            </table>
        </td> 
    </tr>
    <tr><td><font color=red>*�Ǳ����缳����: ������� <%= (double)  amt_tot2/ amt_tot *100 %> %</font></td></tr>
    <tr> 
        <td align="right"><%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	    ����ڿ��� �޼��� ������ :&nbsp;<a href='javascript:bank_massges_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_msg.gif align=absmiddle border=0></a>
	    <%}%>&nbsp;</td>
    </tr>
    
    <% if ( vt_size > 0 ) { %> 
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
   
     <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
			<% for(int i=0; i< vt_size; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
			%>
			
				<tr>
					<td class="title" width="10%">����</td>
					<td class="title" width="15%">�μ�</td>
					<td class="title" width="10%">��å</td>
					<td class="title" width="10%">��ǥ��ȭ</td>
					<td class="title" width="10%">������ȭ</td>
					<td class="title" width="10%">�ѽ�</td>
					<td class="title" width="10%">�޴���</td>
				</tr>
				<tr>
					<td rowspan="4" colspan="1" align="center">
					<%=ht.get("EMP_NM")%>
					<%if(!String.valueOf(ht.get("EMP_LEVEL")).equals("")&&!String.valueOf(ht.get("POS")).equals("")){%><%=ht.get("POS")%><%}else{%><%=ht.get("POS")%><%=ht.get("EMP_LEVEL")%><%}%>
					</td>
					<td align="center"><%=ht.get("DEPT_NM")%></td>
					<td align="center"><%=ht.get("POS")%></td>
					<td align="center"><%=ht.get("EMP_TEL")%></td>
					<td align="center"><%=ht.get("EMP_HTEL")%></td>
					<td align="center"><%=ht.get("EMP_FAX")%></td>
					<td align="center"><a href="javascript:sms_send('<%=ht.get("EMP_NM")%>','<%=ht.get("EMP_MTEL")%>')"><%=ht.get("EMP_MTEL")%></a></td>
				</tr>
				<tr>
					<td rowspan="1" class="title">E-mail</td>
					<td class="title" width="10%">�ϰ��߼۱���</td>
					<td class="title" width="10%">���ʵ��</td>
					<td class="title" width="10%">������</td>
					<td class="title" width="10%">������</td>
					<td class="title" width="10%">��ȿ����</td>
				</tr>
				<tr>
					<td rowspan="1" align="center"><%=ht.get("EMP_EMAIL")%></td>
					<td align="center" ><%if(ht.get("EMP_EMAIL_YN").equals("N")){%>����<%}else{%>���<%}%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UPT_DT")))%></td>
					<td align="center" ><%=ht.get("EMP_ROLE")%></td>
					<td align="center"><%if(ht.get("EMP_VALID").equals("1")){%>��ȿ
					<%}else if(ht.get("EMP_VALID").equals("2")){%>�μ�����
					<%}else if(ht.get("EMP_VALID").equals("3")){%>����
					<%}else if(ht.get("EMP_VALID").equals("4")){%>��ȿ
					<%}%>
					</td>
					
				</tr>
				<tr>
					<td class="title">�ּ�</td>
					<td rowspan="1" colspan="6">&nbsp;&nbsp;(<%=ht.get("EMP_POST")%>)&nbsp;&nbsp;<%=ht.get("EMP_ADDR")%></td>
				</tr>
				<%}%>
			</table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <% } %>
    
</table>
</form>
</body>
</html>
