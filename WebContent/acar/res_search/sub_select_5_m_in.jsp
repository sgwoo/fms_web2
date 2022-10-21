<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_ls_hpg.*, acar.car_register.*"%>
<jsp:useBean id="oh_db" scope="page" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_register.CarMaintBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");		
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	if(cmd.equals("i")){
		cm_bean.setCar_mng_id(c_id);
		cm_bean.setSeq_no(request.getParameter("seq_no")==null?1:AddUtil.parseInt(request.getParameter("seq_no")));
		cm_bean.setChe_kd(request.getParameter("che_kd")==null?"":request.getParameter("che_kd"));				//점검종별
		cm_bean.setChe_st_dt(request.getParameter("che_st_dt")==null?"":request.getParameter("che_st_dt"));		//점검정비유효기간1
		cm_bean.setChe_end_dt(request.getParameter("che_end_dt")==null?"":request.getParameter("che_end_dt"));	//점검정비유효기간2
		cm_bean.setChe_dt(request.getParameter("che_dt")==null?"":request.getParameter("che_dt"));				//점검정비점검일자
		cm_bean.setChe_no(request.getParameter("che_no")==null?"":request.getParameter("che_no"));				//실시자고유번호
		cm_bean.setChe_comp(request.getParameter("che_comp")==null?"":request.getParameter("che_comp"));		//실시자업체명
		
		count = crd.insertCarMaint(cm_bean);
	}
	
	//차량정보
	Hashtable offlh = oh_db.getOfflshpgCase("", "", c_id);
	
	CarMaintBean cm_r [] = crd.getCarMaintAll(c_id);
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;
		fm.cmd.value = 'i';
		if(fm.che_dt.value == ''){ alert('점검일자를 입력하십시오'); fm.che_dt.focus(); return; }
		if(fm.che_st_dt.value == '' || fm.che_end_dt.value == ''){ alert('점검정비 유효기간을 입력하십시오'); fm.che_st_dt.focus(); return; }		
		if(fm.che_no.value == ''){ alert('정비담당자를 입력하십시오'); fm.che_no.focus(); return; }				
		if(fm.che_comp.value == ''){ alert('점검업체를 입력하십시오'); fm.che_comp.focus(); return; }						
		fm.submit();
	}
//-->
</script>
</head>
<body onLoad="self.focus()">
<form name="form1" method="post" action="sub_select_5_m_in.jsp">
 <input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='rent_st' value='<%=rent_st%>'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>	
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='cmd' value=''> 
<table border=0 cellspacing=0 cellpadding=0 width=460>
  <tr>
    <td class=line>            
      <table border=0 cellspacing=1 width=750>
        <%for(int i=0; i<cm_r.length; i++){
			cm_bean = cm_r[i];%>
        <tr> 
          <td width=30 align="center"><%=i+1%></td>
          <td width=80 align="center"><a href="javascript:parent.SetCarServ('<%=cm_bean.getCar_mng_id()%>', '<%=cm_bean.getSeq_no()%>', '<%=cm_bean.getChe_kd()%>', '<%=cm_bean.getChe_no()%>','<%=cm_bean.getChe_comp()%>', '<%=AddUtil.ChangeDate2(cm_bean.getChe_dt())%>')"><%=AddUtil.ChangeDate2(cm_bean.getChe_dt())%></a></td>
            <td width=150 align="center"><%=cm_bean.getChe_kd()%></td>
            <td width=170 align="center"><%=cm_bean.getChe_st_dt()%>~<%=cm_bean.getChe_end_dt()%></td>
          <td width=100 align="center"><%=cm_bean.getChe_no()%></td>
            <td width=220 align="center"><%=cm_bean.getChe_comp()%></td>
        </tr>
        <%} %>
        <tr> 
            <td align=center height=25>추가<input type='hidden' name='seq_no' value='<%=cm_r.length+1%>'></td>
            <td align=center height=25> 
              <input type="text" name="che_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align=center height=25> 
              <input type="text" name="che_kd" value="" size="18" class=text>
            </td>
          <td align=center height=25>
              <input type="text" name="che_st_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
              ~
              <input type="text" name="che_end_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
          <td align=center height=25>
              <input type="text" name="che_no" value="" size="10" class=text>
            </td>
          <td align=center height=25>
              <input type="text" name="che_comp" value="" size="20" class=text>
              &nbsp;<a href='javascript:save();' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
            </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
</body>
</html>