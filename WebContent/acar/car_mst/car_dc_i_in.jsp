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
	
	if(car_comp_id.equals("")) car_comp_id="0001";
	
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] =cmb.getCarNmAll(car_comp_id,code);
	
	//제조사DC관리 리스트
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarDcBean [] cs_r = a_cmb.getCarDcList(car_comp_id, code, car_u_seq, view_dt);
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript">
<!--
	function UpdateCarDcDisp(car_u_seq, car_d_seq, car_d_dt, car_d, car_d_p, car_d_per, car_d_p2, car_d_per2, ls_yn, car_d_per_b, car_d_per_b2, car_d_dt2, idx){
		var theForm = parent.document.form1;	
		theForm.car_u_seq.value 	= car_u_seq;
		theForm.car_d_seq.value 	= car_d_seq;
		theForm.car_d.value 		= car_d;
		theForm.car_d_dt.value 		= ChangeDate3(car_d_dt);	
		theForm.car_d_p.value 		= parseDecimal(car_d_p);		
		theForm.car_d_per.value 	= car_d_per;		
		theForm.car_d_per_b.value 	= car_d_per_b;		
		theForm.car_d_per_b2.value 	= car_d_per_b2;		
		if(ls_yn == 'Y'){
			parent.tr_ls1.style.display 	= "";
			parent.tr_ls2.style.display 	= "";
			theForm.car_d_p2.value 		= parseDecimal(car_d_p2);		
			theForm.car_d_per2.value 	= car_d_per2;	
		}else{
			parent.tr_ls1.style.display 	= "none";
			parent.tr_ls2.style.display 	= "none";			
			theForm.car_d_p2.value 		= "0";		
			theForm.car_d_per2.value 	= "0";	
		}
		theForm.car_d_dt2.value 		= ChangeDate3(car_d_dt2);
		var str = $("#hiddenDiv_"+idx).html();
		var str2 = $("#hiddenDiv_2_"+idx).html();
		theForm.car_d_etc.value 	= str;		//제조사DC 비고 추가(2018.01.22)
		theForm.esti_d_etc.value = str2;		//제조사DC 견적서 기타문구 추가(2020.05.07)
	}	
//-->
</script>
</head>
<body>
<form action="./car_dc_null_ui.jsp" name="CarNmForm" method="POST">
<input type="hidden" name="cmd" value="">
<%	if(cs_r.length > 0){%>
<table border=0 cellspacing=0 cellpadding=0 width="680">
    <tr>
        <td class=line>            
        <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <%	for(int i=0; i<cs_r.length; i++){
			        cd_bean = cs_r[i];%>
          <tr> 
            <td align=center width="7%"><%=i+1%></td>
            <td align=center width="29%"><%=cd_bean.getCar_d()%></td>			
            <td align=center width="7%"><a href="javascript:UpdateCarDcDisp('<%=cd_bean.getCar_u_seq()%>','<%=cd_bean.getCar_d_seq()%>','<%=cd_bean.getCar_d_dt()%>','<%=cd_bean.getCar_d()%>','<%=cd_bean.getCar_d_p()%>','<%=cd_bean.getCar_d_per()%>','<%=cd_bean.getCar_d_p2()%>','<%=cd_bean.getCar_d_per2()%>','<%=cd_bean.getLs_yn()%>','<%=cd_bean.getCar_d_per_b()%>','<%=cd_bean.getCar_d_per_b2()%>','<%=cd_bean.getCar_d_dt2()%>','<%=i%>')" onMouseOver="window.status=''; return true"><%=cd_bean.getCar_d_per()%>%</a></td>
            <td align=right width="15%"><%=AddUtil.parseDecimal(cd_bean.getCar_d_p())%>원</td>
            <td align=center width="4%"><%=cd_bean.getLs_yn()%></td>						
            <td align=center width="7%"><%=cd_bean.getCar_d_per2()%>%</td>			
            <td align=right width="15%"><%=AddUtil.parseDecimal(cd_bean.getCar_d_p2())%>원</td>
            <td align=center width="13%"><%=AddUtil.ChangeDate2(cd_bean.getCar_d_dt())%><%if(!cd_bean.getCar_d_dt2().equals("")){%><br>~ <%=AddUtil.ChangeDate2(cd_bean.getCar_d_dt2())%><%}%></td>
            <td align=center width="5%"><%=cd_bean.getHp_flag()%>
            	<div style="display:none;"><pre id="hiddenDiv_<%=i%>" style="white-space: pre-wrap; word-wrap: break-word;"><%=cd_bean.getCar_d_etc()%></pre></div>
            	<div style="display:none;"><pre id="hiddenDiv_2_<%=i%>" style="white-space: pre-wrap; word-wrap: break-word;"><%=cd_bean.getEsti_d_etc()%></pre></div>
            </td>
          </tr>
          <%	}	%>
        </table>
        </td>
    </tr>
</table>
<%	}%>                             
</form>
</body>
</html>