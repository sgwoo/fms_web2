<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="coev_bean" class="acar.car_office.CarOffEmpVisBean" scope="page"/>
<jsp:useBean id="coc_bean" class="acar.car_office.CarOffCngBean" scope="page"/>
<jsp:useBean id="coh_bean" class="acar.car_office.CarOffEdhBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "04", "04");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String cng_rsn = request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	coe_bean = cod.getCarOffEmpBean(emp_id);
	
	CarCompBean cc_r [] = cod.getCarCompAll();			//�ڵ���ȸ��
	CodeBean cd_r [] = c_db.getCodeAllCms("0003");	//������� �����´�.
	
	
	//�޸����
	CarOffEmpVisBean coev_r [] = cod.getCarOffEmpVisAll(emp_id);
	
	Vector commis = cod.getCommiList(emp_id);
	String firm_nm = "";
	if(commis.size() > 0){
		Hashtable ht = (Hashtable)commis.elementAt(0);
		firm_nm = (String)ht.get("FIRM_NM");
	}
	Vector commis2 = cod.getCommiList(emp_id, coe_bean.getEmp_ssn());
	
	
	//�ٹ�ó����
	CarOffCngBean[] cngs = cod.getCarOffCng(emp_id);
	
	//����ں����̷�
	CarOffEdhBean[] cohList  = cod.getCar_off_edh(emp_id); 
	coh_bean = cohList[cohList.length-1];
	
	//��Ÿ���¸���Ʈ
	Vector acc_vt = c_db.getBankAccList("emp_id", emp_id, "");
	int acc_vt_size = acc_vt.size();

	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "CAR_OFF_EMP";
	String content_seq  = emp_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src='/include/common.js'></script>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
	var popObj = null;
<!--
function go_page(arg){
	if(arg=="i"){
		document.location.href = "./car_office_p_i.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>";
	}else if(arg=="u"){
		document.location.href = "./car_office_p_u.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>&br_id=<%= br_id %>&emp_id=<%= emp_id %>&gubun=<%= gubun %>&gu_nm=<%= gu_nm %>&cng_rsn=<%=cng_rsn%>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>";
	}else if(arg=="b"){
		document.location.href = "./car_office_p_frame.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun=<%= gubun %>&gu_nm=<%= gu_nm %>&cng_rsn=<%=cng_rsn%>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>";	
	}else{
		alert("�߸� ���õǾ����ϴ�.");
	}
}
function go_list(){
	var fm = document.CarOffEmpForm;
	fm.action  = "./car_office_p_frame.jsp";
	fm.target = "d_content";
	fm.submit();
}
function OpenMemo(emp_id)
{
	var theForm = document.CarOffEmpUpdateForm;
	var auth_rw = theForm.auth_rw.value;
	var SUBWIN="./office_memo_i.jsp?emp_id="+emp_id + "&auth_rw=" +auth_rw;	
	window.open(SUBWIN, "Memo", "left=100, top=100, width=570, height=320, scrollbars=no");
}
function VisReg()
{
	var theForm = document.CarOffEmpForm;
	if(!confirm('����Ͻðڽ��ϱ�?')){		return;	}
	theForm.cmd.value = "i";
	theForm.target = "i_no"
	theForm.action = "office_memo_null_ui.jsp";
	theForm.submit();
}
function open_commi(emp_id){
	var SUBWIN="./cont_list.jsp?emp_id="+emp_id;	
	window.open(SUBWIN, "commi_list", "left=20, top=20, width=900, height=500, scrollbars=yes");
}
function open_commi2(emp_id, emp_ssn){
	var SUBWIN="./cont_list2.jsp?emp_id="+emp_id+"&emp_ssn="+emp_ssn;	
	window.open(SUBWIN, "commi_list", "left=20, top=20, width=900, height=500, scrollbars=yes");
}
function view_memo(arg){
	if(arg=="all"){
		memoall.style.display = '';
		memolast.style.display = "none";
	}else{
		memoall.style.display = 'none';
		memolast.style.display = "";
	}
}
function view_car_off_cng(arg){
	if(arg=="all"){
		coall.style.display = '';
		coall2.style.display = '';
	}else if(arg="last"){
		coall.style.display = 'none';
		coall2.style.display = 'none';
		colast.style.display = "";
	}
}
function update_list(){
	var SUBWIN="./update_list.jsp?emp_id=<%= emp_id %>";	
	window.open(SUBWIN, "update_list", "left=100, top=100, width=440, height=320, scrollbars=yes");	
}
function sms_list(arg){
	var SUBWIN="/acar/sms_gate/sms_result_sc2.jsp?dest_gubun=1&rslt_dt=0&dest_nm="+arg;
	window.open(SUBWIN, "sms_list", "left=100, top=100, width=850, height=600, scrollbars=yes");	
}
function damdang_list(){
	var SUBWIN="./damdang_list.jsp?emp_id=<%= emp_id %>";	
	window.open(SUBWIN, "update_list", "left=100, top=100, width=440, height=320, scrollbars=yes");	
}


	//�˾������� ����
	function MM_openBrWindow(theURL,fileExtension,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		
		if(fileExtension == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
			popObj =window.open('',winName,features);

		}else{
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+""+fileExtension;
			popObj =window.open('',winName,features);
			//window.open('/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL,'popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}	
		popObj.location = theURL;
		popObj.focus();	
	}
	
	//��ĵ���
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&emp_id=<%=emp_id%>&from_page=/acar/car_office/car_office_p_s.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	//��ĵ����
	function scan_del(file_st){
		var theForm = document.CarOffEmpForm;
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
		theForm.file_st.value = file_st;
		theForm.target = "i_no"
		theForm.action = "del_scan_a.jsp";
		theForm.submit();
	}
	
	//�����Ұ��°���
	function BankAccMng(){
		var theForm = document.CarOffEmpForm;
		var emp_id = theForm.emp_id.value;		
		var SUBWIN="./car_offemp_bank.jsp?emp_id="+emp_id;	
		window.open(SUBWIN, "OfficeBank", "left=100, top=100, width=920, height=500, scrollbars=yes");
	}	
	
	
	//��õ¡������������
	function go_receipt(){
		var theForm = document.CarOffEmpForm;
		var emp_id = theForm.emp_id.value;		
		var SUBWIN="/acar/commi_mng/commi_receipt.jsp?emp_id="+emp_id;	
		window.open(SUBWIN, "OfficeBank", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	

	//�������� ���
	function printCommi(){
		var theForm = document.CarOffEmpForm;
		var emp_id = theForm.emp_id.value;	
		var SUMWIN = "/acar/commi_mng/printCommi.jsp?emp_id="+emp_id;	
		window.open(SUMWIN, "j", "left=50, top=50, width=820, height=800, scrollbars=yes, status=yes");			
	}	
//-->
</script>

</head>

<body>
<form action="./car_off_null_p_ui.jsp" name="CarOffEmpForm" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gu_nm" value="<%=gu_nm%>">
<input type="hidden" name="emp_id" value="<%=emp_id%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="file_st" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�������� > ����������� > <span class=style1><span class=style5>���������ȸ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td><div align="right">
	    <%if(cmd.equals("")){%>
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:go_page('i')"> <img src=../images/center/button_reg_new.gif align=absmiddle border=0></a> <a href="javascript:go_page('u')"> <img src=../images/center/button_modify_s.gif align=absmiddle border=0></a>
        <%}%>
        <a href="javascript:go_page('b')"> <img src=../images/center/button_list.gif align=absmiddle border=0></a> &nbsp; 
        <a href="javascript:go_receipt()"><img src=/acar/images/center/button_receipt.gif align=absmiddle border=0></a>  &nbsp;       
        <a href="javascript:printCommi();">[�������� �߱�]</a>&nbsp;&nbsp;
       
        </div>
	    <%}%>
	    </td>		
    </tr>
    <tr>
        <td>
	        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ڰ���</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td width="100%" class="line">
            		    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td width="15%" class="title">�����</td>
                                <td width="35%">&nbsp; <%= c_db.getNameById(coh_bean.getDamdang_id(),"USER") %></td>
                                <td width="15%" class="title">����(����)����</td>
                                <td width="35%">&nbsp; <%= AddUtil.ChangeDate2(coh_bean.getCng_dt()) %></td>
                            </tr>
                            <tr>
                                <td class="title">��������</td>
                                <td>&nbsp;
                                    <% if(coh_bean.getCng_rsn().equals("1"))	 out.print("1.�ֱٰ��");
                				  			else if(coh_bean.getCng_rsn().equals("2")) out.print("2.�����");
                				  			else if(coh_bean.getCng_rsn().equals("3")) out.print("3.��ȭ���");
                				  			else if(coh_bean.getCng_rsn().equals("4")) out.print("4.�������");
                				  			else if(coh_bean.getCng_rsn().equals("5")) out.print("5.��Ÿ"); %>
                                </td>
                                <td class="title">�����̷�</td>
                                <td>&nbsp;
                                    <% if(cohList.length>1){ %>
                                    <a href="javascript:damdang_list()" ><img src=../images/center/button_in_list.gif align=absmiddle border=0></a>
                                    <% }else{ %>
                                    ����
                                    <% } %></td>
                            </tr>
                        </table>
		            </td>
                </tr>
                <tr> 
                    <td class=h></td>
                </tr>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ʻ��װ���</span></td>
                </tr>
                <tr>
                    <td>
            		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
            		        <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                				    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td width="15%" class="title">����</td>
                                            <td width="35%">&nbsp; <%= coe_bean.getEmp_nm() %></td>
                                            <td width="5%" rowspan="2" class="title">��<br>��<br>ó</td>
                                            <td width="10%" class="title">��ȭ</td>
                                            <td width="35%">&nbsp; <%= coe_bean.getEmp_h_tel() %></td>
                                        </tr>
                                        <tr>
                                            <td class="title">�ҵ汸��</td>
                                            <td>&nbsp;
                                              <input type="radio" name="cust_st" value="2"  <% if(coe_bean.getCust_st().equals("2")) out.println("checked"); %>>
                                            ����ҵ�&nbsp;
                                            <input type="radio" name="cust_st" value="3"  <% if(coe_bean.getCust_st().equals("3")) out.println("checked"); %>>
                                            ��Ÿ����ҵ�</td>
                                            <td class="title">�ڵ���</td>
                                            <td>&nbsp; <%= coe_bean.getEmp_m_tel() %></td>
                                        </tr>
                                        <tr>
                                            <td class="title">�ֹε�Ϲ�ȣ</td>
                                            <td>&nbsp; <%= coe_bean.getEmp_ssn1() %> - ******* </td>
                                            <td colspan="2" class="title">����</td>
                                            <td>&nbsp;
                                              <input type="radio" name="emp_sex" value="2"  <% if(coe_bean.getEmp_sex().equals("1")) out.println("checked"); %>>
                                            ����
                                            <input type="radio" name="emp_sex" value="3"  <% if(coe_bean.getEmp_sex().equals("2")) out.println("checked"); %>>
                                            ���� </td>
                                        </tr>
                                        <tr>
                                            <td class="title">���ּ�</td>
                                            <td colspan="4">&nbsp; <%= coe_bean.getEmp_post() %> &nbsp; <%= coe_bean.getEmp_addr() %></td>
                                        </tr>
                                        <tr>
                                            <td class="title">�����ּ�</td>
                                            <td colspan="4">&nbsp; <%= coe_bean.getEmp_email() %></td>
                                        </tr>
                                    </table>
            				    </td>
                            </tr>
                        </table>
		            </td>
                </tr>
                <tr> 
                    <td class=h></td>
                </tr>
                <tr>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ٹ�ó����</span></td>
                                <td align=right>
                                  <% if(cngs.length>0){ %>
                                  <a href="javascript:view_car_off_cng('all')"><img src=../images/center/button_see_all.gif align=absmiddle border=0></a>&nbsp; <a href="javascript:view_car_off_cng('last')"><img src=../images/center/button_cancel.gif align=absmiddle border=0></a>
                                  <% } %>
                                  <% if(coev_r.length>0 && cngs.length>0){ %>
                                  <a href="javascript:update_list()"><span title="������ �̷��� �� �� �ֽ��ϴ�."><img src=../images/center/button_bgir.gif align=absmiddle border=0></span></a>
                                  <% } %>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="coall" style="display:none;">
                    <td>
		                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <% for(int j=0; j<cngs.length; j++){
            				 	coc_bean = cngs[j];
            					co_bean = cod.getCarOffBean(coc_bean.getCar_off_id()); %>
                            <tr>
                                <td style='font-size:8pt'>&nbsp;&nbsp;<font color=red><%= j+1 %>. �����ٹ�ó</font></td>
                            </tr>
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line" >
            				        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td colspan="2" class="title">���ۻ��</td>
                                            <td>&nbsp;
                                              <%for(int i=0; i<cc_r.length; i++){
                    							cc_bean = cc_r[i];
                    							
                    							if(cc_bean.getCode().equals(co_bean.getCar_comp_id())) out.print(cc_bean.getNm());
                    						} %>
                                            </td>
                                            <td colspan="2" class="title">����</td>
                                            <td>&nbsp; <%= coc_bean.getEmp_pos() %></td>
                                        </tr>
                                        <tr>
                                            <td width="5%" rowspan="2" class="title">��<br>��<br>ó</td>
                                            <td width="10%" class="title">��ȣ(�μ���)</td>
                                            <td width="35%">&nbsp; <%= co_bean.getCar_off_nm() %></td>
                                            <td width="5%" rowspan="2" class="title">��<br>��<br>ó</td>
                                            <td width="10%" class="title">��ȭ</td>
                                            <td width="35%">&nbsp; <%= co_bean.getCar_off_tel() %></td>
                                        </tr>
                                        <tr>
                                            <td class="title">����</td>
                                            <td>&nbsp;
                                              <input type="radio" name="car_off_st_old<%= j %>" value="1" <% if(co_bean.getCar_off_st().equals("1")) out.println("checked"); %>>
                                            ����
                                            <input type="radio" name="car_off_st_old<%= j %>" value="2" <% if(co_bean.getCar_off_st().equals("2")) out.println("checked"); %>>
                                            �븮��</td>
                                            <td class="title">FAX</td>
                                            <td>&nbsp; <%= co_bean.getCar_off_fax() %></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="title">�ּ�</td>
                                            <td colspan="4">&nbsp; <%= co_bean.getCar_off_post() %>&nbsp;<%= co_bean.getCar_off_addr() %></td>
                                        </tr>
                                    </table>
            				    </td>
                            </tr>
                          <% } %>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                <tr id="coall2" style="display:none;">
                    <td>
		                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style='font-size:8pt'>&nbsp;&nbsp;<font color=red><%= cngs.length+1 %>. ����ٹ�ó</font></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="colast" style="display:'';">
                    <td>
            		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
            		        <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                				    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td colspan="2" class="title">���ۻ��</td>
                                            <td>&nbsp;
                                              <%for(int i=0; i<cc_r.length; i++){
                    							cc_bean = cc_r[i];
                    							if(cc_bean.getCode().equals(coe_bean.getCar_comp_id())) out.print(cc_bean.getNm());
                    						} %>
                                            </td>
                                            <td colspan="2" class="title">����</td>
                                            <td>&nbsp; <%= coe_bean.getEmp_pos() %></td>
                                        </tr>
                                        <tr>
                                            <td width="5%" rowspan="2" class="title">��<br>��<br>ó</td>
                                            <td width="10%" class="title">��ȣ(�μ���)</td>
                                            <td width="35%">&nbsp; <%= c_db.getNameById(coe_bean.getCar_off_id(),"CAR_OFF") %></td>
                                            <td width="5%" rowspan="2" class="title">��<br>��<br>ó</td>
                                            <td width="10%" class="title">��ȭ</td>
                                            <td width="35%">&nbsp; <%= coe_bean.getCar_off_tel() %></td>
                                        </tr>
                                        <tr>
                                            <td class="title">����</td>
                                            <td>&nbsp;
                                              <input type="radio" name="car_off_st" value="1" <% if(coe_bean.getCar_off_st().equals("1")) out.println("checked"); %>>
                                            ����
                                            <input type="radio" name="car_off_st" value="2" <% if(coe_bean.getCar_off_st().equals("2")) out.println("checked"); %>>
                                            �븮��</td>
                                            <td class="title">FAX</td>
                                            <td>&nbsp; <%= coe_bean.getCar_off_fax() %></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="title">�ּ�</td>
                                            <td colspan="4">&nbsp; <%= coe_bean.getCar_off_post() %>&nbsp;<%= coe_bean.getCar_off_addr() %></td>
                                        </tr>
                                    </table>
                				</td>
                            </tr>
                        </table>
		            </td>
                </tr>
                <tr> 
                    <td class=h></td>
                </tr>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ��°���</span></td>
                </tr>
                <tr>
                    <td>
            		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
            		        <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                				    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td width="15%" class="title">�����</td>
                                            <td width="35%">&nbsp;
                                              <select name="emp_bank" disabled style="width:135">
                                                <option value="">==����==</option>
                                                <%for(int i=0; i<cd_r.length; i++){
                    							cd_bean = cd_r[i];%>
                                                <option value="<%= cd_bean.getCode() %>" <% if(cd_bean.getNm().equals(coe_bean.getEmp_bank())||cd_bean.getCode().equals(coe_bean.getBank_cd())) out.print("selected"); %>><%= cd_bean.getNm() %></option>
                                                <%}%>
                                            </select></td>
                                            <td width="15%" class="title">�����ָ�</td>
                                            <td width="35%">&nbsp; <%= coe_bean.getEmp_acc_nm() %></td>
                                        </tr>
                                        <tr>
                                            <td class="title">���¹�ȣ</td>
                                            <td colspan="3">&nbsp; <%= coe_bean.getEmp_acc_no() %></td>
                                        </tr>
                                    </table>
                				</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class=h></td>
                </tr>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ǽ�����</span></td>
                </tr>
                <tr>
                    <td>
            		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
            		        <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                				    <table width="100%" border="0" cellspacing="1" cellpadding="0">
										<tr>
                                            <td width="15%" class="title">��ϳ���
                                            </td>
                                            <td width="85%">&nbsp; 
											  <%if(acc_vt_size>0){
											  		Hashtable ht = (Hashtable)acc_vt.elementAt(0);%>
											  		<%=ht.get("ACC_NM")%>
													<% if(acc_vt_size>1) out.print("�� "+acc_vt_size+"��"); %>&nbsp;&nbsp;
	                                              	<% if(acc_vt_size>0){ %>
                                              		<a href="javascript:BankAccMng()" onMouseOver="window.status=''; return true"><span title="Ŭ���Ͻø� ������ �� �� �ֽ��ϴ�."><img src=../images/center/button_in_search.gif align=absmiddle border=0></span></a>
                                              		<% }else{ %>
                                            		&nbsp;
                                            		<% } %>											   
											  <%}else{%>	
											  <%    if(!auth_rw.equals("1")){%>										  
											  <a href="javascript:BankAccMng()" onMouseOver="window.status=''; return true">[�Ǽ����ε��]</a>
											  <%    }%>
											  <%}%>
                                            </td>
                                        </tr>
                                    </table>
                				</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class=h></td>
                </tr>				
                <tr>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ŷ� ���� ���ǿ��</span></td>
                                <td align=right>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td width="15%" class="title">����
                                            </td>
                                            <td width="85%">&nbsp;<%= coe_bean.getFraud_care() %></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>                
                <tr> 
                    <td class=h></td>
                </tr>				
                <tr>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������(�޸�)</span></td>
                                <td align=right><% if(coev_r.length>1){ %>
                                  <a href="javascript:view_memo('all')"><img src=../images/center/button_see_all.gif align=absmiddle border=0></a>&nbsp; <a href="javascript:view_memo('last')"><img src=../images/center/button_cancel.gif align=absmiddle border=0></a>
                                  <% } %>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>                
                <tr>
                    <td>
            		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
            		        <tr>
                                <td class=line2></td>
                            </tr>
                            <tr id="memolast" style="display:<% if(coev_r.length>0){ %>''<% }else{ %>none<% } %>;">
                                <td class="line">
                				    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <%if(coev_r.length>0){
                    					    	coev_bean = coev_r[coev_r.length-1]; %>
                                        <tr>
                                          <td width="15%" class="title">�޸�<%= coev_r.length %></td>
                                          <td width="85%">&nbsp;
                                              <textarea name="cont" rows="2" cols="100" readonly><%= coev_bean.getVis_cont() %></textarea></td>
                                        </tr>
                                        <% } %>
                                    </table>
                                </td>
                            </tr>
                            <tr id="memoall" style="display:none;">
                                <td class="line">
                				    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <%for(int i=0; i<coev_r.length; i++){
                    					    	coev_bean = coev_r[i]; %>
                                        <tr>
                                            <td width="15%" class="title">�޸�<%= i+1 %></td>
                                            <td width="85%">&nbsp;
                                              <textarea name="cont" rows="2" cols="100" readonly><%= coev_bean.getVis_cont() %></textarea></td>
                                        </tr>
                                        <% } %>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td width="15%"  class="title">�޸�</td>
                                            <td width="85%">&nbsp;
                                              <textarea name="vis_cont" rows="2" cols="100"></textarea> <%if(!auth_rw.equals("1")){%><a href="javascript:VisReg()"><span title="������ �Է��Ͻð� Ŭ���ϸ�, �߰��˴ϴ�"><img src=../images/center/button_in_plus.gif align=absmiddle border=0></span></a><%}%></td>
                                            <input type="hidden" name="sub" value="�޸�<%= coev_r.length+1 %>">
                                            <input type="hidden" name="vis_nm" value="<%= user_id %>">
                                            <input type="hidden" name="vis_dt" value="<%= AddUtil.dateFormat("yyyyMMdd") %>">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class=h></td>
                </tr>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������/���޼��������</span></td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td width="15%" class="title">�ŷ�����
                                            </td>
                                            <td width="85%">&nbsp; <%= firm_nm %>
                                              <% if(commis.size()>0) out.print("�� "+commis.size()+"��"); %>&nbsp;&nbsp;
                                              <% if(commis.size()>0){ %>
                                              <a href="javascript:open_commi('<%= emp_id %>')"><span title="Ŭ���Ͻø� ������ �� �� �ֽ��ϴ�."><img src=../images/center/button_in_search.gif align=absmiddle border=0></span></a>
                                              <% }else{ %>
                                              &nbsp;
                                              <% } %>
                                              <% if(commis2.size()>0){ %>
                                              (�Ǽ����� �ŷ� : <%=commis2.size()%>��
                                              <a href="javascript:open_commi2('<%= emp_id %>','<%= coe_bean.getEmp_ssn() %>')"><span title="Ŭ���Ͻø� ������ �� �� �ֽ��ϴ�."><img src=../images/center/button_in_search.gif align=absmiddle border=0></span></a>
                                              )
                                              <% } %>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class=h></td>
                </tr>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>SMS����</span></td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td width="15%" class="title">���ſ���</td>
                                            <td width="35%">&nbsp;
                                              <input type="radio" name="use_yn" value="Y" disabled <% if(coe_bean.getUse_yn().equals("Y")) out.print("checked"); %>>
                                            ����&nbsp;&nbsp;
                                            <input type="radio" name="use_yn" value="N" disabled <% if(coe_bean.getUse_yn().equals("N")) out.print("checked"); %>>
                                            �ź�</td>
                                            <td width="15%" class="title">���ڹ߼�</td>
                                            <td width="35%">&nbsp;<a href="javascript:sms_list('<%= coe_bean.getEmp_nm() %>');"><img src=../images/center/button_in_list.gif align=absmiddle border=0></a></td>
                                        </tr>
                                        <% if(coe_bean.getUse_yn().equals("N")){ %>
                                        <tr>
                                            <td class="title">���Űźλ���</td>
                                            <td colspan="3">&nbsp; <%= coe_bean.getSms_denial_rsn() %></td>
                                        </tr>
                                        <% } %>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class=h></td>
                </tr>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ĵ����</span></td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <%
                            	String emp_file1_yn = "";
                            	String emp_file2_yn = "";
                            %>
                            <tr>
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td width="15%" class="title">�ź���</td>
                                            <td width="85%">&nbsp;                                                                                                
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"1")){
    									emp_file1_yn = "Y";
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}%>
    						<%if(emp_file1_yn.equals("")){%>
                                                <a href="javascript:scan_reg('1')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a>
                                                <%}%>
                                                
                                                </td>
                                        </tr>
                                        <tr>
                                            <td width="15%" class="title">����</td>
                                            <td width="85%">&nbsp;                                                
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"2")){
    									emp_file2_yn = "Y";
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    							
    						<%		}%>		
    						<%	}%>		
    						<%}%>
    						<%if(emp_file2_yn.equals("")){%>
                                                <a href="javascript:scan_reg('2')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a>
                                                <%}%>
                                                
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="50" height="50" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>
