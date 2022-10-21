<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cd_bean" class="acar.car_mst.CarDcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_u_seq 	= request.getParameter("car_u_seq")	==null?"":request.getParameter("car_u_seq");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String upd_d_dt 	= request.getParameter("upd_d_dt")==null?"":request.getParameter("upd_d_dt");
	
	if(car_comp_id.equals("")) car_comp_id="0001";
	
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] =cmb.getCarNmAll(car_comp_id,code);
	
	//제조사DC관리 리스트
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarDcBean [] cs_r = a_cmb.getCarDcDtList(upd_d_dt);
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function UpdateCarDcDisp(car_u_seq, car_d_seq, car_d_dt, car_d, car_d_p, car_d_per, car_d_p2, car_d_per2, ls_yn, car_d_per_b, car_d_per_b2){
		var theForm = parent.document.CarNmForm;	
		theForm.car_u_seq.value 	= car_u_seq;
		theForm.car_d_seq.value 	= car_d_seq;
		theForm.car_d.value 		= car_d;
		theForm.car_d_dt.value 		= ChangeDate3(car_d_dt);	
		theForm.car_d_p.value 		= parseDecimal(car_d_p);		
		theForm.car_d_per.value 	= car_d_per;		
		theForm.car_d_per_b.value 	= car_d_per_b;		
		theForm.car_d_per_b2.value 	= car_d_per_b2;		
		theForm.ls_yn.value 		= ls_yn;		
		if(ls_yn == 'Y'){
			theForm.car_d_p2.value 		= parseDecimal(car_d_p2);		
			theForm.car_d_per2.value 	= car_d_per2;	
		}else{
			theForm.car_d_p2.value 		= "0";		
			theForm.car_d_per2.value 	= "0";	
		}
		
		if(!confirm('삭제하시겠습니까?')){	return;	}
		theForm.cmd.value = "d";
		theForm.target="i_no";
		theForm.action="car_dc_null_ui.jsp";
		theForm.submit();
		
	}	
	
	function Search(){
		var fm2 = document.CarNmForm;		
		fm2.target="_self";
		fm2.action="car_dc_list.jsp";
		fm2.submit();
	}	
	
	//로딩시
	function re_init(st){
					
	}	
//-->
</script>
</head>
<body>
<form action="./car_dc_null_ui.jsp" name="CarNmForm" method="POST" >
  <input type="hidden" name="car_u_seq" value="">
  <input type="hidden" name="car_d_seq" value="">
  <input type="hidden" name="car_d" value="">
  <input type="hidden" name="car_d_dt" value="">
  <input type="hidden" name="car_d_p" value="">    
  <input type="hidden" name="car_d_per" value="">
  <input type="hidden" name="car_d_per_b" value="">
  <input type="hidden" name="car_d_per_b2" value="">
  <input type="hidden" name="ls_yn" value="">
  <input type="hidden" name="car_d_p2" value=""> 
  <input type="hidden" name="car_d_per2" value="">   
  <input type="hidden" name="cmd" value="">   

<input type="hidden" name="cmd" value="">
<%	if(cs_r.length > 0){%>
<table border=0 cellspacing=0 cellpadding=0 width="840">
    <tr>
        <td class=line>            
        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                        <tr> 
                          <td width="30" rowspan="2" class=title>연번</td>
                          <td width="90" rowspan="2" class=title>제조사</td>						  
                          <td width="100" rowspan="2" class=title>차명</td>						  
                          <td width="200" rowspan="2" class=title>D/C구분</td>						                                                      
                          <td colspan="2" class=title>공통/렌트</td>
                          <td colspan="3" class=title>리스</td>
                          <td width="70" rowspan="2" class=title>기준일자</td>
                          <td width="40" rowspan="2" class=title>삭제</td>
                        </tr>
                        <tr>
                          <td width="50" class=title>D/C율</td>
                          <td width="80" class=title>D/C금액</td>
                          <td width="50" class=title>상이</td>						  						  
                          <td width="50" class=title>D/C율</td>
                          <td width="80" class=title>D/C금액</td>
                          
                        </tr>        
          <%	for(int i=0; i<cs_r.length; i++){
			        cd_bean = cs_r[i];%>
          <tr> 
            <td align=center ><%=i+1%></td>
            <td align=center ><%=cd_bean.getCar_comp_nm()%></td>			
            <td align=center ><%=cd_bean.getCar_nm()%></td>			
            <td align=center ><%=cd_bean.getCar_d()%></td>			
            <td align=center ><%=cd_bean.getCar_d_per()%>%</td>
            <td align=right ><%=AddUtil.parseDecimal(cd_bean.getCar_d_p())%>원</td>
            <td align=center ><%=cd_bean.getLs_yn()%></td>						
            <td align=center ><%=cd_bean.getCar_d_per2()%>%</td>			
            <td align=right ><%=AddUtil.parseDecimal(cd_bean.getCar_d_p2())%>원</td>
            <td align=center ><%=AddUtil.ChangeDate2(cd_bean.getCar_d_dt())%></td>
            <td align=center ><a href="javascript:UpdateCarDcDisp('<%=cd_bean.getCar_u_seq()%>','<%=cd_bean.getCar_d_seq()%>','<%=cd_bean.getCar_d_dt()%>','<%=cd_bean.getCar_d()%>','<%=cd_bean.getCar_d_p()%>','<%=cd_bean.getCar_d_per()%>','<%=cd_bean.getCar_d_p2()%>','<%=cd_bean.getCar_d_per2()%>','<%=cd_bean.getLs_yn()%>','<%=cd_bean.getCar_d_per_b()%>','<%=cd_bean.getCar_d_per_b2()%>')" onMouseOver="window.status=''; return true">[삭제]</a></td>
          </tr>
          <%	}	%>
        </table>
        </td>
    </tr>
</table>
<%	}%>                             
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>