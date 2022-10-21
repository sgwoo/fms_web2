<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cs_bean" class="acar.car_mst.CarSelBean" scope="page"/>
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
		fm.action = 'car_sel_a.jsp';			
		fm.target = "i_no";
		fm.submit();
	}		
	
	function search(){
		var fm = document.form1;
		fm.target='popwin1';
		fm.action="car_sel.jsp";
		fm.submit();
	}
	
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.car_s[0].focus()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");	
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	//차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//기준일자
	Vector cars = a_cmb.getSearchCode(cm_bean.getCar_comp_id(), cm_bean.getCode(), "", "", "5", "");
	int car_size = cars.size();
	
	//선택사양 리스트		
	CarSelBean [] cs_r = a_cmb.getCarSelList(cm_bean.getCar_comp_id(), cm_bean.getCode(), cm_bean.getCar_seq(), view_dt);
%>
<form action="./car_sel_a.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">   
  <input type="hidden" name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
  <input type="hidden" name="car_cd" value="<%=cm_bean.getCode()%>">
  <input type="hidden" name="car_id" value="<%=cm_bean.getCar_id()%>">
  <input type="hidden" name="car_seq" value="<%=cm_bean.getCar_seq()%>">
  <input type="hidden" name="car_nm" value="<%=car_nm%>">    
  <input type="hidden" name="car_b_dt" value="<%=cm_bean.getCar_b_dt()%>">
  <input type="hidden" name="cmd" value="<%=cmd%>">
  <input type="hidden" name="size" value="<%=cs_r.length%>">  
  <input type="hidden" name="mode" value="">  
  <input type="hidden" name="h_car_s_seq" value="">
  <input type="hidden" name="h_car_s" value="">
  <input type="hidden" name="h_car_s_p" value="">
  <input type="hidden" name="h_car_s_dt" value="">
  <input type="hidden" name="h_use_yn" value="">  
  <table border=0 cellspacing=0 cellpadding=0 width="820">
    <tr> 
      <td width="800"> 
        <table border="0" cellspacing="0" cellpadding="0" width="800">
          <tr> 
            <td width="800"><img src="../off_ls_hpg/img/icon_red.gif" width="7" height="7" aligh="absmiddle" border="0"> 
              차명 : <%=car_nm%>&nbsp;&nbsp;&nbsp;<img src="../off_ls_hpg/img/icon_red.gif" width="7" height="7" aligh="absmiddle" border="0"> 
              기준일자: 
              <select name="view_dt" onChange="javascript:search()">
                <option value="0" <%if(view_dt.equals("0"))%>selected<%%>>전체</option>
                <%for(int i = 0 ; i < car_size ; i++){
					Hashtable car = (Hashtable)cars.elementAt(i);%>
                <option value="<%=car.get("CAR_S_DT")%>" <%if(view_dt.equals("") || view_dt.equals(String.valueOf(car.get("CAR_S_DT"))))%>selected<%%>><%=AddUtil.ChangeDate2(String.valueOf(car.get("CAR_S_DT")))%></option>
                <%}%>
              </select>
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
            <td class=title width="430">옵션명</td>
            <td class=title width="100">가격</td>
            <td class=title width="90">기준일자</td>
            <td class=title width="60">사용여부</td>
            <td class=title width="90">처리</td>
          </tr>
          <tr> 
            <td align="center" width="30">추가 
              <input type="hidden" name="car_s_seq" value="">
            </td>
            <td width="430"> 
              <input type="text" name="car_s" value="" size="50" class=text style='IME-MODE: active'>
            </td>
            <td align="right" width="100"> 
              <input type="text" name="car_s_p" value="" size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
              원</td>
            <td align="center" width="90"> 
              <input type="text" name="car_s_dt" size="12" value="2004-03-24" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align="center" width="60"> 
              <input type="checkbox" name="use_yn" value="Y" checked>
            </td>
            <td align="center" width="90"><a href="javascript:Save('i', '')">등록</a></td>
          </tr>
          <%	for(int i=0; i<cs_r.length; i++){
			        cs_bean = cs_r[i];%>
          <tr> 
            <td align="center"> 
              <input type="text" name="car_s_seq" value="<%=cs_bean.getCar_s_seq()%>" size="1" class=whitetext>
            </td>
            <td> 
              <input type="text" name="car_s" value='<%=cs_bean.getCar_s()%>' size="50" class=text>
            </td>
            <td align="right"> 
              <input type="text" name="car_s_p" value="<%=AddUtil.parseDecimal(cs_bean.getCar_s_p())%>" size="8" class=num>
              원</td>
            <td align="center"> 
              <input type="text" name="car_s_dt" value="<%=AddUtil.ChangeDate2(cs_bean.getCar_s_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align="center"> 
              <input type="checkbox" name="use_yn" value="Y" <%if(cs_bean.getUse_yn().equals("Y"))%>checked<%%>>
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
