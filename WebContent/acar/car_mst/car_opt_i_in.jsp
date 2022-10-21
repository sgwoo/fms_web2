<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="co_bean" class="acar.car_mst.CarOptBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function UpdateCarDcDisp(car_u_seq, car_s_seq, car_s, car_s_p, car_s_dt, opt_b, use_yn, jg_opt_st, jg_tuix_st, lkas_yn, ldws_yn, aeb_yn, fcw_yn, garnish_yn, hook_yn){
		var theForm = parent.document.form1;	
		theForm.car_u_seq.value = car_u_seq;
		theForm.car_s_seq.value = car_s_seq;
		theForm.car_s.value = car_s;
		theForm.car_s_p.value = parseDecimal(car_s_p);		
		theForm.car_s_dt.value = ChangeDate3(car_s_dt);		
		theForm.opt_b.value = opt_b;
		theForm.use_yn.value = use_yn;
		theForm.jg_opt_st.value = jg_opt_st;
		theForm.jg_tuix_st.value = jg_tuix_st;
		theForm.lkas_yn.value = lkas_yn;
		theForm.ldws_yn.value = ldws_yn;
		theForm.aeb_yn.value = aeb_yn;
		theForm.fcw_yn.value = fcw_yn;
		theForm.garnish_yn.value = garnish_yn;
		theForm.hook_yn.value = hook_yn;
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 		= request.getParameter("car_u_seq")==null?"":request.getParameter("car_u_seq");	
	String view_dt 		= request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	
	//옵션관리 리스트
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarOptBean [] co_r = a_cmb.getCarOptList(car_comp_id, code, car_id, car_seq, "");
	
%>
<form action="./car_dc_null_ui.jsp" name="CarNmForm" method="POST" >
<input type="hidden" name="cmd" value="">
<%	if(co_r.length > 0){%>
<table border=0 cellspacing=0 cellpadding=0 width="1180">
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <%	for(int i=0; i<co_r.length; i++){
			        co_bean = co_r[i];%>
                <tr> 
                    <td align=center width=3%><%=i+1%></td>
                    <td width=20%>&nbsp;<a href="javascript:UpdateCarDcDisp('<%=co_bean.getCar_u_seq()%>','<%=co_bean.getCar_s_seq()%>','<%=co_bean.getCar_s()%>','<%=co_bean.getCar_s_p()%>','<%=co_bean.getCar_s_dt()%>','<%=co_bean.getOpt_b()%>','<%=co_bean.getUse_yn()%>','<%=co_bean.getJg_opt_st()%>','<%=co_bean.getJg_tuix_st()%>','<%=co_bean.getLkas_yn()%>','<%=co_bean.getLdws_yn()%>','<%=co_bean.getAeb_yn()%>','<%=co_bean.getFcw_yn()%>','<%=co_bean.getGarnish_yn()%>','<%=co_bean.getHook_yn()%>')" onMouseOver="window.status=''; return true"><%=co_bean.getCar_s()%></a></td>
                    <td width=*>&nbsp;<%=co_bean.getOpt_b()%></td>
                    <td width=5%>&nbsp;<%=co_bean.getJg_opt_st()%></td>
                    <td align=center width=6%><%if(co_bean.getJg_tuix_st().equals("Y")){%>해당<%}%></td><!-- TUIX/TUON 옵션여부 -->
                    <td align=center width=5%><%if(co_bean.getLkas_yn().equals("Y")){%>해당<%}%></td><!-- 차선이탈 제어형 -->
                    <td align=center width=5%><%if(co_bean.getLdws_yn().equals("Y")){%>해당<%}%></td><!-- 차선이탈 경고형 -->
                    <td align=center width=5%><%if(co_bean.getAeb_yn().equals("Y")){%>해당<%}%></td><!-- 긴급제동 제어형 -->
                    <td align=center width=5%><%if(co_bean.getFcw_yn().equals("Y")){%>해당<%}%></td><!-- 긴급제동 경고형 -->
                    <td align=center width=5%><%if(co_bean.getGarnish_yn().equals("Y")){%>해당<%}%></td><!-- 가니쉬 -->
					<td align=center width=7%><%if(co_bean.getHook_yn().equals("Y")){%>해당<%}%></td><!-- 견인고리 -->
                    <td align=right width=7%><%=AddUtil.parseDecimal(co_bean.getCar_s_p())%>원</td>
                    <td align=center width=7%><%=AddUtil.ChangeDate2(co_bean.getCar_s_dt())%></td>
                    <td align=center width=5%><%=co_bean.getUse_yn()%></td>
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