<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_pre.Offls_preBean"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>
<jsp:useBean id="auction" scope="page" class="acar.offls_actn.Offls_auctionBean"/>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	detail = olpD.getPre_detail(car_mng_id);
	apprsl = olpD.getPre_apprsl(car_mng_id);
	auction = olaD.getAuction(car_mng_id, olaD.getAuction_maxSeq(car_mng_id));
	
	//���������
	Vector actns = olpD.getActns();
	
	//�����ü����Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	//��ǰ�� ���� ��� �����ϱ� ����
	String apprsl_car_mng_id = olyD.getApprsl_Car_mng_id(car_mng_id);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function apprslUpd(ioru)
{
	var fm = document.form1;	
	var apprsl_dt = ChangeDate2(fm.apprsl_dt.value);
	if(apprsl_dt != ""){
		if(ioru=="i"){
			if(!confirm('�򰡳����� ����Ͻðڽ��ϱ�?')){ return; }
		}else if(ioru=="u"){
			if(!confirm('�򰡳����� �����Ͻðڽ��ϱ�?')){ return; }
		}
		fm.gubun.value = ioru;
		fm.action="/acar/off_ls_pre/off_ls_pre_apprsl_upd.jsp";
		fm.target = "i_no";	
		fm.submit();
	}else{
		alert("�����ڸ� �Է��ϼ���!");
		return;
	}
}
function add_actn(){
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	var SUBWIN = "off_ls_pre_actn_i.jsp"+url;
	window.open(SUBWIN, "View_ADD_ACTN", "left=100, top=100, width=820, height=400, resizable=no, scrollbars=no");
}

//�˻��ϱ�
function caroff_search(){
		var fm = document.form1;	
		
		if (fm.gov_nm.value == "") { alert("�˻�� �Է��ϼ���!"); return; }
		
		window.open("/acar/car_doc_reg/caroffemp_search.jsp?s_kd=car_off_nm&t_wd="+fm.gov_nm.value, "SEARCH_CAROFF", "left=200, top=200, width=750, height=500, scrollbars=yes");
}
	
-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">


<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǰ��</span></td>
        <td align="right"> 
            <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
          <%if(apprsl_car_mng_id.equals("")){%>
          <a href='javascript:apprslUpd("i");' onMouseOver="window.status=''; return true"> 
          <img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp; 
          <%}else{%>
          <a href='javascript:apprslUpd("u");' onMouseOver="window.status=''; return true"> 
          <img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
          <%}%>
          <%}%>
            <a href='javascript:history.go(-1);' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a> 
          </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0"  width=100%>
                <tr> 
                  <td width=16% height="22" class='title'> ��ü��</td>
                  <td width=21%>&nbsp; <select name='lev'>
                      <option value='0'>����</option>
                      <option value='1' <%if(apprsl.getLev().equals("1")){%>selected<%}%>>��</option>
                      <option value='2' <%if(apprsl.getLev().equals("2")){%>selected<%}%>>��</option>
                      <option value='3' <%if(apprsl.getLev().equals("3")){%>selected<%}%>>��</option>
                    </select> </td>
                  <td class='title' width=14%>������</td>
                  <td width=49%>&nbsp; <input  class="text" type="text" name="apprsl_dt" size="20" value="<%=AddUtil.ChangeDate2(apprsl.getApprsl_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                  </td>
                </tr>
                <tr> 
                  <td class='title'>�򰡿���</td>
                  <td colspan="3">&nbsp; <textarea  class="textarea" name="reason" cols="70" rows="2"><%=apprsl.getReason()%></textarea> 
                  </td>
                </tr>
                <tr> 
                  <td class='title'>��������</td>
                  <td colspan="3">&nbsp; <input  class="text" type="text" name="car_st" size="70" value="<%=apprsl.getCar_st()%>"> 
                  </td>
                </tr>
                <tr> 
                  <td class='title'>�������</td>
                  <td> &nbsp; <select name='sago_yn'>
                      <option value=''>����</option>
                      <option value='Y' <%if(apprsl.getSago_yn().equals("Y")){%>selected<%}%>>��</option>
                      <option value='N' <%if(apprsl.getSago_yn().equals("N")){%>selected<%}%>>��</option>
                    </select> </td>
                  <td class="title">LPG����</td>
                  <td> &nbsp; <select name='lpg_yn'>
                      <option value=''>����</option>
                      <option value='1' <%if(apprsl.getLpg_yn().equals("1")){%>selected<%}%>>��</option>
                      <option value='0' <%if(apprsl.getLpg_yn().equals("0")){%>selected<%}%>>��</option>
                      <option value='2' <%if(apprsl.getLpg_yn().equals("2")){%>selected<%}%>>Ż��</option>
                    </select> </td>
                </tr>
                <tr> 
                  <td class='title'>������������Ÿ�</td>
                  <td> &nbsp; <input  class="num" type="text" name="km" size="20" value="<%=AddUtil.parseDecimal(apprsl.getKm())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                    KM </td>
                  <td class='title'>��ǰ�����</td>
                  <td> <select name='client_id'>
                      <option value=''>����</option>
                      <%for(int i=0; i<actns.size(); i++){
        					Hashtable ht = (Hashtable)actns.elementAt(i);%>
                      <option value='<%=ht.get("CLIENT_ID")%>' <%if(ht.get("CLIENT_ID").equals(apprsl.getActn_id())){%>selected<%}%>><%=ht.get("FIRM_NM")%></option>
                      <%}%>
                    </select> &nbsp; 
                    <%//<a href='javascript:add_actn();' onMouseOver="window.status=''; return true"> 
                      //<img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="�߰�"></a> 
                    %>
                    &nbsp;<input  class="text" type="text" name="actn_wh" size="10" value="<%=apprsl.getActn_wh()%>" >
                  </td>
                </tr>
                              
                <tr> 
                  <td class='title'>�������</td>
                  <td colspan="3"> &nbsp; <textarea  class="textarea" name="damdang" cols="70" rows="2"><%=apprsl.getDamdang()%></textarea> 
                  </td>
                </tr>
                <tr> 
                  <td class='title'>������������ȣ</td>
                  <td> &nbsp;&nbsp; 
                    <%if(detail.getCar_pre_no().equals("")){%>
                    ���� 
                    <%}else{%>
                    <%=detail.getCar_pre_no()%> &nbsp; 
                    <%}%>
                  </td>
                  <td class="title">������ȣ������</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(detail.getCha_dt())%> </td>
                </tr>
                <tr> 
                  <td class='title'>�����</td>
                  <td>&nbsp; <select name="damdang_id">
                      <option value='' <%if(apprsl.getDamdang_id().equals("")){%>selected<%}%>>����</option>
                      <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	
        %>
                      <option value='<%=user.get("USER_ID")%>' <%if(apprsl.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                      <%
        						}
        					}		%>
                    </select> </td>
                  <td class="title">����������</td>
                  <td>&nbsp; 
                    <%if(login.getAcarName(apprsl.getModify_id()).equals("error")){%>
                    &nbsp; 
                    <%}else{%>
                    <%=login.getAcarName(apprsl.getModify_id())%> 
                    <%}%>
                    &nbsp; </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
