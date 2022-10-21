<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.common.*, acar.cus_reg.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	ClientBean client = al_db.getClient(client_id);
	
	////Vector c_sites = al_db.getClientSites(client_id);
	//int c_site_size = c_sites.size();
	Vector conts = l_db.getContList(client_id);
	int cont_size = conts.size();
	//���������
	CusReg_Database cr_db = CusReg_Database.getInstance();	
	Vector mngs = cr_db.getMng(client_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//Hashtable ht = cr_db.
	Hashtable ht = cr_db.getCycle_vst(client_id);
	Cycle_vstBean[] list = cr_db.getCycle_vstList(client_id);
	
	
	//height
	//int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//int cnt = 12; //��Ȳ ��� ������ �Ѽ�
	//int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	//out.println("aa=" + height );
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//����������ϱ�
function create_scd_vst(){
	var fm = document.form1;
	if(fm.first_vst_dt.value==""){	alert("���ʹ湮���� �Է��� �ּ���!"); fm.first_vst_dt.focus();	return; }
	if(fm.cycle_vst_mon.value==""){	alert("�湮�ֱ� ������ �Է��� �ּ���!"); fm.cycle_vst_mon.focus();	return; }
	//if(fm.cycle_vst_day.value==""){	alert("�湮�ֱ� ���ڸ� �Է��� �ּ���!"); fm.cycle_vst_day.focus();	return; }
	if(fm.tot_vst.value==""){	alert("�ѹ湮Ƚ���� �Է��� �ּ���!"); fm.tot_vst.focus();	return; }
	if(get_length(fm.tot_vst.value)>2){	alert("�ִ� �� �湮Ƚ���� 99ȸ�����Դϴ�."); fm.tot_vst.focus(); return; }
	if(!confirm("�������� �����Ͻðڽ��ϱ�?"))		return;	
	fm.action = "create_scd_vst.jsp";		
	fm.target = 'i_no';	
	fm.submit();
}
function extend_scd_vst(){
	var fm = document.form1;
	if(!confirm("�������� �߰� �����Ͻðڽ��ϱ�?"))		return;
	fm.action = "extend_scd_vst.jsp";
	fm.target = "i_no";
	fm.submit();
}
function ext_last_cont(){
	var fm = document.form1;
	if(fm.cycle_vst_mon.value==""){	alert("�湮�ֱ� ������ �Է��� �ּ���!"); fm.cycle_vst_mon.focus();	return; }
	if(get_length(fm.tot_vst.value)>2){	alert("�ִ� �� �湮Ƚ���� 99ȸ�����Դϴ�."); fm.tot_vst.focus(); return; }
	if(!confirm("��������ϱ��� �����Ͻðڽ��ϱ�?")) return;
	fm.action = "extend_last_cont.jsp";
	fm.target = "i_no";
	fm.submit();
}
function deleteScdVst(seq){
	var fm = document.form1;
	fm.seq.value = seq;
	if(!confirm("�ش� �������� �����Ͻðڽ��ϱ�?"))	 return;
	fm.action = "delete_scd_vst.jsp";
	fm.target = "i_no";
	fm.submit();	
}
//�����湮�Ϻ���
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="client_id" value="<%= client_id %>">
<input type="hidden" name="seq" value="">
<table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
                <tr> 
                    <td class=line colspan="2"> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                              <td class='title'>��ȣ</td>
                              <td class='left'>&nbsp;<b><%=client.getFirm_nm()%></b></td>
                              <td class=title>�����</td>
                              <td class='left' colspan="3">&nbsp;<%=client.getClient_nm()%></td>
                            </tr>
                            <tr> 
                              <td class='title'>��뺻����</td>
                              <td class='left' colspan="5">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class='title'>����� �ּ�</td>
                              <td class='left' colspan="5">&nbsp; <%if(!client.getO_addr().equals("")){%>
                                ( 
                                <%}%> <%=client.getO_zip()%> <%if(!client.getO_addr().equals("")){%>
                                )&nbsp; <%}%> <%=client.getO_addr()%></td>
                            </tr>
                            <tr> 
                              <td class='title' width=13%>ȸ����ȭ��ȣ</td>
                              <td class='left' width=24%>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
                              <td class='title' width=12%>�޴���</td>
                              <td class='left' width=20%>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
                              <td class='title' width=12%>������ȭ��ȣ</td>
                              <td class='left' width=19%>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ฮ��Ʈ</span></td>
                    <td align="right"><img src=/acar/images/center/arrow.gif align=absmiddle> �������� ��� �Ǽ� : 
                    <input type='text' name='valid_cont_cnt' class='whitenum' size='4' value='' readonly>
                    ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>                
                <tr> 
                    <td colspan="2">
                        <table border="0" cellspacing="0" cellpadding="0" width=100%>
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                              <td class='line'> 
                                    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                                  <!-- ����ڵ�, �����, ������ȣ, ����, ���Ⱓ, �뿩���, �뿩�Ⱓ, �뿩����, �������//-->
                                      <tr> 
                                        <td width='13%' class=title>����ȣ</td>
                                        <td width='12%' class=title>�����</td>
                                        <td width='13%' class=title>������ȣ</td>
                                        <td width='17%' class=title>����</td>
                                        <td width='18%' class=title>���Ⱓ</td>
                                        <td width='9%' class=title>�뿩���</td>
                                        <td width='9%' class=title>�������</td>
                                        <td width='9%' class=title>�뿩����</td>
                                      </tr>
                                    </table>
                               </td>
                              <td width=16></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2"><iframe src="cus_reg_con_s.jsp?client_id=<%=client_id%>" name="inner1" width="100%" height="<%if(cont_size>=4){ out.print("90"); 
    		  }else if(cont_size==3){ 
    		  	out.print("70"); 
    		  }else if(cont_size==2){
    		  	out.print("50"); 
    		  }else if(cont_size==1){ 
    		  	out.print("30"); 
    		  }else{
    		  } %>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                  </iframe></td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr> 
                    <td valign="bottom"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ŷ�ó�湮 ������</span></td>
                    <td align="right"> 
                  <!--<font color="#666666"> �� <a href="javascript:MM_openBrWindow('client_loop2.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=600,height=600,top=50,left=50')">�ŷ�ó�湮�ֱ�</a> 
                  : <font color="#FF0000">�Ѵ�</font></font>-->
                    </td>
                </tr>
                <tr> 
                    <td colspan="2"> 
                        <table border="0" cellspacing="0" cellpadding="0" width='100%'>
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class=line>
                                    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                                        <tr> 
                                          <td class='title' width=13%>���������</td>
                                          <td width=13%>&nbsp;<% for(int i = 0 ; i < mngs.size() ; i++){
                        			String mng_id = (String)mngs.elementAt(i);
                        			out.print(c_db.getNameById(mng_id,"USER")+" ");
                        			}%></td>
                                          <td class='title' width=12%>���ʹ湮����</td>
                                          <td width=13%>&nbsp; <input type="text" name="first_vst_dt" size="12" class=text value="<%= AddUtil.ChangeDate2((String)ht.get("FIRST_VST_DT")) %>" onBlur='javascript:this.value=ChangeDate(this.value);'> 
                                          </td>
                                          <td class='title' width=12%>�湮�ֱ�</td>
                                          <td width=13%>&nbsp; <input type="text" name="cycle_vst_mon" size="2" class=text value="<%= ht.get("CYCLE_VST_MON") %>">
                                            ���� 
                                            <input type="text" name="cycle_vst_day" size="2" class=text value="<%= ht.get("CYCLE_VST_DAY") %>">
                                            ��</td>
                                          <td class='title' width=12%>�ѹ湮Ƚ��</td>
                                          <td width=13%>&nbsp; <input type="text" name="tot_vst" size="3" class=text value="<%= ht.get("TOT_VST") %>">
                                            ȸ</td>
                                           
                                        </tr>
                                    </table>
                                </td>
                                <td width=16>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td  align="left">&nbsp;</td>
                    <td  align="right">
        			  <% if(list.length>0){ %>
        			        <a href="javascript:MM_openBrWindow('vst_reg.jsp?client_id=<%= client_id %>','popwin_vst_reg','scrollbars=yes,status=no,resizable=no,width=850,height=350,top=50,left=50')"><img src=/acar/images/center/button_reg_bjg.gif align=absmiddle border=0></a>&nbsp; 
                            <a href="javascript:MM_openBrWindow('scd_vst_cng_dt.jsp?client_id=<%= client_id %>','popwin_scd_vst_cng_dt','scrollbars=no,status=no,resizable=no,width=550,height=200,top=200,left=300')"><img src=/acar/images/center/button_modify_yji.gif align=absmiddle border=0></a>&nbsp; 
        			        <a href="javascript:ext_last_cont()"><img src=/acar/images/center/button_gy_yj.gif align=absmiddle border=0></a>
        			  <% }else{ %>
                      	    <a href="javascript:create_scd_vst()"><img src=/acar/images/center/button_sch_cre.gif align=absmiddle border=0></a> 
                      <% } %>&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                    <td></td>
                </tR>
                <tr> 
                    <td colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></tD>
                            </tr>
                            <tr> 
                              <td class="line">
                                <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                                  <tr> 
                                    <td class='title' width=4%>ȸ��</td>
                                    <td class='title' width=11%>�湮������</td>
                                    <td class='title' width=11%>�湮����</td>
                                    <td class='title' width=10%>�湮��</td>
                                    <td class='title' width=12%>�湮����</td>
                                    <td class='title' width=11%>�����</td>
                                    <td class='title' width=25%>��㳻��</td>
                                    <td class='title' width=8%>���</td>
                                    <td class='title' width=8%>����</td>
                                  </tr>
                                </table></td>
                                <td width=16>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2"><iframe src="cus_reg_visit_in.jsp?client_id=<%=client_id%>" name="scd_vst" width="100%" height="130" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</html>
