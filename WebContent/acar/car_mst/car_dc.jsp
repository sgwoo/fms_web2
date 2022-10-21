<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cd_bean" class="acar.car_mst.CarDcBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function Save(mode, idx){
		var fm = document.form1;
		var size = toInt(fm.size.value);
		var ment;
		if(mode == 'u'){
			fm.h_car_d_seq.value = fm.car_d_seq[toInt(idx)+1].value;
			fm.h_car_d.value 	 = fm.car_d[toInt(idx)+1].value;
			fm.h_car_d_p.value 	 = fm.car_d_p[toInt(idx)+1].value;
			fm.h_car_d_st.value  = fm.car_d_st[toInt(idx)+1].value;
			fm.h_car_d_et.value  = fm.car_d_et[toInt(idx)+1].value;			
			ment = '수정';
		}else if(mode == 'd'){
			fm.h_car_d_seq.value = fm.car_d_seq[toInt(idx)+1].value;
			fm.h_car_d.value 	 = fm.car_d[toInt(idx)+1].value;
			fm.h_car_d_p.value 	 = fm.car_d_p[toInt(idx)+1].value;
			fm.h_car_d_st.value  = fm.car_d_st[toInt(idx)+1].value;
			fm.h_car_d_et.value  = fm.car_d_et[toInt(idx)+1].value;			
			ment = '삭제';
		}else{
			if(size == 0){
				fm.h_car_d_seq.value = fm.car_d_seq.value;
				fm.h_car_d.value 	 = fm.car_d.value;
				fm.h_car_d_p.value 	 = fm.car_d_p.value;
				fm.h_car_d_st.value  = fm.car_d_st.value;
				fm.h_car_d_et.value  = fm.car_d_et.value;
			}else{
				fm.h_car_d_seq.value = fm.car_d_seq[0].value;
				fm.h_car_d.value 	 = fm.car_d[0].value;
				fm.h_car_d_p.value 	 = fm.car_d_p[0].value;
				fm.h_car_d_st.value  = fm.car_d_st[0].value;
				fm.h_car_d_et.value  = fm.car_d_et[0].value;
			}
			ment = '등록';			
		}		
		if(fm.h_car_d.value == ''){ alert('DC내용을 확인하십시오'); return; }
		if(fm.h_car_d_p.value == ''){ alert('DC금액을 확인하십시오'); return; }
		if(fm.h_car_d_st.value == ''){ alert('적용시작일를 확인하십시오'); return; }		
		if(fm.h_car_d_et.value == ''){ alert('적용만료일를 확인하십시오'); return; }				
		
		if(!confirm(ment+'하시겠습니까?')){	return;	}
		fm.mode.value = mode;
		fm.action = 'car_dc_a.jsp';			
		fm.target = "i_no";
		fm.submit();
	}		
	
	function search(){
		var fm = document.form1;
		fm.target='popwin3';
		fm.action="car_dc.jsp";
		fm.submit();
	}
	
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	//차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//색상관리 리스트
	CarDcBean [] cs_r = a_cmb.getCarDcList(cm_bean.getCar_comp_id(), cm_bean.getCode(), cm_bean.getCar_seq(), view_dt);
%>
<form action="./car_dc_a.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">   
  <input type="hidden" name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
  <input type="hidden" name="car_cd" value="<%=cm_bean.getCode()%>">
  <input type="hidden" name="car_id" value="<%=cm_bean.getCar_id()%>">
  <input type="hidden" name="car_b_dt" value="<%=cm_bean.getCar_b_dt()%>">
  <input type="hidden" name="car_nm" value="<%=car_nm%>">  
  <input type="hidden" name="cmd" value="<%=cmd%>">
  <input type="hidden" name="size" value="<%=cs_r.length%>">  
  <input type="hidden" name="mode" value="">  
  <input type="hidden" name="h_car_d_seq" value="">
  <input type="hidden" name="h_car_d" value="">
  <input type="hidden" name="h_car_d_p" value="">
  <input type="hidden" name="h_car_d_st" value="">
  <input type="hidden" name="h_car_d_et" value="">  
  <table border=0 cellspacing=0 cellpadding=0 width="820">
    <tr> 
      <td width="800"> 
        <table border="0" cellspacing="0" cellpadding="0" width="800">
          <tr> 
            <td><img src="../off_ls_hpg/img/icon_red.gif" width="7" height="7" aligh="absmiddle" border="0"> 
              차명 : <%=car_nm%>
            </td>
          </tr>
        </table>
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class=line width="800"> 
        <table border="0" cellspacing="1" cellpadding="3" width="800">
          <tr> 
            <td class=title width="30">연번</td>
            <td class=title width="430">DC내용</td>
            <td class=title width="100">DC금액</td>
            <td class=title width="90">적용시작일</td>
            <td class=title width="60">적용만료일</td>
            <td class=title width="90">처리</td>
          </tr>
          <tr> 
            <td align="center" width="30">추가 
              <input type="hidden" name="car_d_seq" value="">
            </td>
            <td width="430"> 
              <input type="text" name="car_d" value="" size="50" class=text>
            </td>
            <td align="right" width="100"> 
              <input type="text" name="car_d_p" value="" size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
              원</td>
            <td align="center" width="90"> 
              <input type="text" name="car_d_st" size="12" value="" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align="center" width="60"> 
              <input type="text" name="car_d_et" size="12" value="" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align="center" width="90"><a href="javascript:Save('i', '')">등록</a></td>
          </tr>
          <%	for(int i=0; i<cs_r.length; i++){
			        cd_bean = cs_r[i];%>
          <tr> 
            <td align="center"> 
              <input type="text" name="car_d_seq" value="<%=cd_bean.getCar_d_seq()%>" size="1" class=whitetext>
            </td>
            <td> 
              <input type="text" name="car_d" value='<%=cd_bean.getCar_d()%>' size="50" class=text>
            </td>
            <td align="right"> 
              <input type="text" name="car_d_p" value="<%=AddUtil.parseDecimal(cd_bean.getCar_d_p())%>" size="8" class=num>
              원</td>
            <td align="center"> 
              <input type="text" name="car_d_st" value="<%=AddUtil.ChangeDate2(cd_bean.getCar_d_st())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align="center"> 
              <input type="text" name="car_d_et" value="<%=AddUtil.ChangeDate2(cd_bean.getCar_d_et())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align="center"> <a href="javascript:Save('u', '<%=i%>')">수정</a> 
              <a href="javascript:Save('d', '<%=i%>')">삭제</a></td>
          </tr>
          <%	}	%>
        </table>
      </td>
      <td width="20" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
    <tr> 
      <td width="800" align="right"><a href="javascript:self.close()">닫기</a></td>
    </tr>    
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
