<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cs_bean" class="acar.car_mst.CarSelBean" scope="page"/>
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
			fm.h_car_s_seq.value = fm.car_s_seq[toInt(idx)+1].value;
			fm.h_car_s.value 	 = fm.car_s[toInt(idx)+1].value;
			fm.h_car_s_p.value 	 = fm.car_s_p[toInt(idx)+1].value;
			fm.h_car_s_dt.value  = fm.car_s_dt[toInt(idx)+1].value;
			fm.h_use_yn.value  = fm.use_yn[toInt(idx)+1].value;	
			ment = '수정';
		}else if(mode == 'd'){
			fm.h_car_s_seq.value = fm.car_s_seq[toInt(idx)+1].value;
			fm.h_car_s.value 	 = fm.car_s[toInt(idx)+1].value;
			fm.h_car_s_p.value 	 = fm.car_s_p[toInt(idx)+1].value;
			fm.h_car_s_dt.value  = fm.car_s_dt[toInt(idx)+1].value;
			fm.h_use_yn.value  = fm.use_yn[toInt(idx)+1].value;			
			ment = '삭제';
		}else{
			if(size == 0){
				fm.h_car_s_seq.value = fm.car_s_seq.value;
				fm.h_car_s.value 	 = fm.car_s.value;
				fm.h_car_s_p.value 	 = fm.car_s_p.value;
				fm.h_car_s_dt.value  = fm.car_s_dt.value;
				fm.h_use_yn.value  	 = fm.use_yn.value;				
			}else{
				fm.h_car_s_seq.value = fm.car_s_seq[0].value;
				fm.h_car_s.value 	 = fm.car_s[0].value;
				fm.h_car_s_p.value 	 = fm.car_s_p[0].value;
				fm.h_car_s_dt.value  = fm.car_s_dt[0].value;
				fm.h_use_yn.value  	 = fm.use_yn[0].value;				
			}
			ment = '등록';			
		}		
		if(fm.h_car_s.value == ''){ alert('옵션명을 확인하십시오'); return; }
		if(fm.h_car_s_p.value == ''){ alert('옵션가격을 확인하십시오'); return; }
		if(fm.h_car_s_dt.value == ''){ alert('기준일자를 확인하십시오'); return; }		
		if(!max_length(fm.h_car_s.value, 200)){ alert('기본사양이 영문200자/한글100자를 초과하였습니다.\n\n확인하십시오'); return; }		
		
		if(!confirm(ment+'하시겠습니까?')){	return;	}
		fm.mode.value = mode;
		fm.action = 'car_mst_s_a.jsp';			
		fm.target = "i_no";
		fm.submit();
	}		
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_b_dt = request.getParameter("car_b_dt")==null?"":request.getParameter("car_b_dt");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
	if(cmd.equals("u")){
		disabled = "";
		white = "";
		readonly = "";
	}
	
	//차종리스트
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();	
	CarSelBean [] cs_r = a_cmd.getCarSelList(car_comp_id, car_cd, car_seq);
%>
<form action="./car_mst_s_a.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">    
  <input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
  <input type="hidden" name="car_cd" value="<%=car_cd%>">
  <input type="hidden" name="car_seq" value="<%=car_seq%>">
  <input type="hidden" name="car_b_dt" value="<%=car_b_dt%>">  
  <input type="hidden" name="cmd" value="<%=cmd%>">
  <input type="hidden" name="size" value="<%=cs_r.length%>">  
  <input type="hidden" name="mode" value="">
  <input type="hidden" name="h_car_s_seq" value="">
  <input type="hidden" name="h_car_s" value="">
  <input type="hidden" name="h_car_s_p" value="">
  <input type="hidden" name="h_car_s_dt" value="">
  <input type="hidden" name="h_use_yn" value="">  
  <table border=0 cellspacing=0 cellpadding=0 width="800">
    <tr>             
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="3" width="800">
          <%if(cmd.equals("u")){%>
          <tr> 
            <td align="center" width="50">추가 
              <input type="hidden" name="car_s_seq" value="">
            </td>
            <td width="400"> 
              <input type="text" name="car_s" value="" size="40" class=text>
            </td>
            <td align="right" width="100"> 
              <input type="text" name="car_s_p" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
              원</td>
            <td align="center" width="100"> 
              <input type="text" name="car_s_dt" size="12" value="<%=AddUtil.ChangeDate2(car_b_dt)%>" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align="center" width="60"> 
              <input type="checkbox" name="use_yn" value="Y">
            </td>
            <td align="center" width="90"><a href="javascript:Save('i', '')">등록</a></td>
          </tr>
          <%}%>
          <%if(cmd.equals("") && cs_r.length == 0){%>
          <tr> 
            <td align="center">등록된 자료가 없습니다.</td>
          </tr>
          <%}%>
          <%	for(int i=0; i<cs_r.length; i++){
			        cs_bean = cs_r[i];%>
          <tr> 
            <td align="center" width="50"> 
              <input type="text" name="car_s_seq" value="<%=cs_bean.getCar_s_seq()%>" size="1" class=whitetext>
            </td>
            <td width="400"> 
              <input type="text" name="car_s" value='<%=cs_bean.getCar_s()%>' size="40" class=<%=white%>text>
            </td>
            <td align="right" width="100"> 
              <input type="text" name="car_s_p" value="<%=AddUtil.parseDecimal(cs_bean.getCar_s_p())%>" size="10" class=<%=white%>num>
              원</td>
            <td align="center" width="100"> 
              <input type="text" name="car_s_dt" value="<%=AddUtil.ChangeDate2(cs_bean.getCar_s_dt())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align="center" width="60"> 
              <input type="checkbox" name="use_yn" value="Y" <%if(cs_bean.getUse_yn().equals("Y"))%>checked<%%>>
            </td>
            <td align="center" width="90"> 
              <%if(cmd.equals("u")){%>
              <a href="javascript:Save('u', '<%=i%>')">수정</a> <a href="javascript:Save('d', '<%=i%>')">삭제</a></td>
            <%}else{%>
            - 
            <%}%>
          </tr>
          <%	}	%>
        </table>
      </td>
    </tr>
</table>
</form>
</body>
</html>
