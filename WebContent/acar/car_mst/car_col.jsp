<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cc_bean" class="acar.car_mst.CarColBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 	= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm 	= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String view_dt 	= request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	//차명정보
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//기준일자
	Vector cars = a_cmb.getSearchCode(cm_bean.getCar_comp_id(), cm_bean.getCode(), "", "", "6", "");
	int car_size = cars.size();
	
	//색상관리 리스트
	CarColBean [] cs_r = a_cmb.getCarColList(cm_bean.getCar_comp_id(), cm_bean.getCode(), cm_bean.getCar_seq(), view_dt);
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function Save(mode, idx){
		var fm = document.form1;
		var size = toInt(fm.size.value);
		var ment;
		if(mode == 'u'){
			fm.h_car_u_seq.value 	= fm.car_u_seq[toInt(idx)+1].value;
			fm.h_car_c_seq.value 	= fm.car_c_seq[toInt(idx)+1].value;
			fm.h_car_c.value 	= fm.car_c[toInt(idx)+1].value;
			fm.h_car_c_p.value 	= fm.car_c_p[toInt(idx)+1].value;
			fm.h_car_c_dt.value  	= fm.car_c_dt[toInt(idx)+1].value;
			fm.h_use_yn.value  	= fm.use_yn[toInt(idx)+1].value;	
			fm.h_etc.value  	= fm.etc[toInt(idx)+1].value;	
			fm.h_col_st.value  	= fm.col_st[toInt(idx)+1].value;	
			fm.h_jg_opt_st.value	= fm.jg_opt_st[toInt(idx)+1].value;
			ment = '수정';
		}else if(mode == 'd'){
			fm.h_car_u_seq.value 	= fm.car_u_seq[toInt(idx)+1].value;
			fm.h_car_c_seq.value 	= fm.car_c_seq[toInt(idx)+1].value;
			fm.h_car_c.value 	= fm.car_c[toInt(idx)+1].value;
			fm.h_car_c_p.value 	= fm.car_c_p[toInt(idx)+1].value;
			fm.h_car_c_dt.value  	= fm.car_c_dt[toInt(idx)+1].value;
			fm.h_use_yn.value  	= fm.use_yn[toInt(idx)+1].value;	
			fm.h_etc.value  	= fm.etc[toInt(idx)+1].value;			
			fm.h_col_st.value  	= fm.col_st[toInt(idx)+1].value;
			fm.h_jg_opt_st.value	= fm.jg_opt_st[toInt(idx)+1].value;			
			ment = '삭제';
		}else{
			if(size == 0){
				fm.h_car_u_seq.value 	= fm.car_seq.value;
				fm.h_car_c_seq.value 	= fm.car_c_seq.value;
				fm.h_car_c.value 	= fm.car_c.value;
				fm.h_car_c_p.value 	= fm.car_c_p.value;
				fm.h_car_c_dt.value  	= fm.car_c_dt.value;
				fm.h_use_yn.value  	= fm.use_yn.value;				
				fm.h_etc.value  	= fm.etc.value;				
				fm.h_col_st.value  	= fm.col_st.value;				
				fm.h_jg_opt_st.value  	= fm.jg_opt_st.value;				
			}else{
				fm.h_car_u_seq.value 	= fm.car_seq.value;
				fm.h_car_c_seq.value 	= fm.car_c_seq[0].value;
				fm.h_car_c.value 	= fm.car_c[0].value;
				fm.h_car_c_p.value 	= fm.car_c_p[0].value;
				fm.h_car_c_dt.value  	= fm.car_c_dt[0].value;
				fm.h_use_yn.value  	= fm.use_yn[0].value;				
				fm.h_etc.value  	= fm.etc[0].value;				
				fm.h_col_st.value  	= fm.col_st[0].value;		
				fm.h_jg_opt_st.value  	= fm.jg_opt_st[0].value;						
			}
			ment = '등록';			
		}		
		if(fm.h_car_c.value == ''){ alert('색상명을 확인하십시오'); return; }
		if(fm.h_car_c_p.value == ''){ alert('가격을 확인하십시오'); return; }
		if(fm.h_car_c_dt.value == ''){ alert('기준일자를 확인하십시오'); return; }		
		
		if(!confirm(ment+'하시겠습니까?')){	return;	}
		fm.mode.value = mode;
		fm.action = 'car_col_a.jsp';			
		//fm.target = "i_no";
		fm.submit();
	}		
	
	function search(){
		var fm = document.form1;
		fm.target='popwin2';
		fm.action="car_col.jsp";
		fm.submit();
	}
	
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.car_c<% if(cs_r.length>0) %>[0]<%  %>.focus()">
<form action="./car_col_a.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">   
  <input type="hidden" name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
  <input type="hidden" name="car_cd" value="<%=cm_bean.getCode()%>">
  <input type="hidden" name="car_id" value="<%=cm_bean.getCar_id()%>">
  <input type="hidden" name="car_seq" value="<%=cm_bean.getCar_seq()%>">
  <input type="hidden" name="car_b_dt" value="<%=cm_bean.getCar_b_dt()%>">
  <input type="hidden" name="car_nm" value="<%=car_nm%>">  
  <input type="hidden" name="cmd" value="<%=cmd%>">
  <input type="hidden" name="size" value="<%=cs_r.length%>">  
  <input type="hidden" name="mode" value="">  
  <input type="hidden" name="h_car_u_seq" value="">
  <input type="hidden" name="h_car_c_seq" value="">
  <input type="hidden" name="h_car_c" value="">
  <input type="hidden" name="h_car_c_p" value="">
  <input type="hidden" name="h_car_c_dt" value="">
  <input type="hidden" name="h_use_yn" value="">  
  <input type="hidden" name="h_etc" value="">  
  <input type="hidden" name="h_col_st" value="">  
  <input type="hidden" name="h_jg_opt_st" value="">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr> 
        <td width="800"> 
            <table border="0" cellspacing="0" cellpadding="0" width="800">
                <tr> 
                    <td>&nbsp;
                        <img src=../images/center/arrow_cm.gif>&nbsp;&nbsp;<b>[ <%=car_nm%> ]</b>&nbsp;&nbsp;
                        <img src=../images/center/arrow_gjij.gif>&nbsp;
                        <select name="view_dt" onChange="javascript:search()">
                        <option value="0" <%if(view_dt.equals("0"))%>selected<%%>>전체</option>
                        <%for(int i = 0 ; i < car_size ; i++){
        					Hashtable car = (Hashtable)cars.elementAt(i);%>
                        <option value="<%=car.get("CAR_C_DT")%>" <%if(view_dt.equals("") || view_dt.equals(String.valueOf(car.get("CAR_C_DT"))))%>selected<%%>><%=AddUtil.ChangeDate2(String.valueOf(car.get("CAR_C_DT")))%></option>
                        <%}%>
                        </select>
                    </td>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
                <tr> 
                    <td class=title width="5%">연번</td>
                    <td class=title width="5%">색상명</td>
                    <td class=title width="24%">색상명</td>
                    <td class=title width="8%">조정잔가</td>
                    <td class=title width="10%">가격</td>
                    <td class=title width="8%">기준일자</td>
                    <td class=title width="24%">비고</td>
                    <td class=title width="6%">사용여부</td>
                    <td class=title width="10%">처리</td>
                </tr>
                <tr> 
                    <td align="center">추가 
                        <input type="hidden" name="car_c_seq" value="">
                        <input type="hidden" name="car_u_seq" value="">
                    </td>
                    <td align="center"> 
                        <select name="col_st">          
                        <option value="">선택</option>              
                        <option value="1">외장</option>
                        <option value="2">내장</option>
                        <option value="3">가니쉬</option>
                      </select>
                    </td>
                    <td align="center"> 
                        <input type="text" name="car_c" value="" size="50" class=text style='IME-MODE: active'>
                    </td>
                    <td align="center"> 
                        <input type="text" name="jg_opt_st" value="" size="5" class=text>
                    </td>
                    <td align="right"> 
                        <input type="text" name="car_c_p" value="0" size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원</td>
                    <td align="center"> 
                        <input type="text" name="car_c_dt" size="12" value="<%= AddUtil.getDate() %>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                        <input type="text" name="etc" value="" size="30" class=text style='IME-MODE: active'>
                    </td>
                    <td align="center"> 
                        <input type="checkbox" name="use_yn" value="Y" checked>
                    </td>
                    <td align="center">
                        <%if(!auth_rw.equals("1")){%>
                        <a href="javascript:Save('i', '')"><img src=../images/center/button_in_reg.gif border=0 align=absmiddle></a>
                        <%}%>
                    </td>
                </tr>
                <%	for(int i=0; i<cs_r.length; i++){
			        cc_bean = cs_r[i];%>
                <tr> 
                    <td align="center"> 
                        <input type="hidden" name="car_u_seq" value="<%=cc_bean.getCar_u_seq()%>">
                        <input type="text" name="car_c_seq" value="<%=cc_bean.getCar_c_seq()%>" size="1" class=whitetext>
                    </td>
                    <td align="center"> 
                        <select name="col_st">          
                        <option value="">선택</option>              
                        <option value="1" <%if(cc_bean.getCol_st().equals("1")){%>selected<%}%>>외장</option>
                        <option value="2" <%if(cc_bean.getCol_st().equals("2")){%>selected<%}%>>내장</option>
                        <option value="3" <%if(cc_bean.getCol_st().equals("3")){%>selected<%}%>>가니쉬</option>
                      </select>
                    </td>                    
                    <td align="center"> 
                        <input type="text" name="car_c" value='<%=cc_bean.getCar_c()%>' size="50" class=text>
                    </td>
                    <td align="center"> 
                        <input type="text" name="jg_opt_st" value="<%=cc_bean.getJg_opt_st()%>" size="5" class=text>
                    </td>                    
                    <td align="right"> 
                        <input type="text" name="car_c_p" value="<%=AddUtil.parseDecimal(cc_bean.getCar_c_p())%>" size="8" class=num>
                        원</td>
                    <td align="center"> 
                        <input type="text" name="car_c_dt" value="<%=AddUtil.ChangeDate2(cc_bean.getCar_c_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                        <input type="text" name="etc" value="<%=cc_bean.getEtc()%>" size="30" class=text style='IME-MODE: active'>
                    </td>
                    <td align="center"> 
                        <input type="checkbox" name="use_yn" value="Y" <%if(cc_bean.getUse_yn().equals("Y"))%>checked<%%>>
                    </td>
                    <td align="center">
                        <%if(!auth_rw.equals("1")){%>
                        <a href="javascript:Save('u', '<%=i%>')"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>
                        <a href="javascript:Save('d', '<%=i%>')"><img src=../images/center/button_in_delete.gif border=0 align=absmiddle></a>
                        <%}%>
                    </td>
                </tr>
                <%	}	%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:self.close()"><img src=../images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
