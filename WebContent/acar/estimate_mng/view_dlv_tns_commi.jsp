<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	
	String rent_dt 	= request.getParameter("rent_dt")	==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");	
	String car_id 	= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String car_seq 	= request.getParameter("car_seq")	==null?"":request.getParameter("car_seq");
	int car_amt 	= request.getParameter("car_amt")	==null? 0:Util.parseDigit(request.getParameter("car_amt"));
	int opt_amt 	= request.getParameter("opt_amt")	==null? 0:Util.parseDigit(request.getParameter("opt_amt"));
	int col_amt 	= request.getParameter("col_amt")	==null? 0:Util.parseDigit(request.getParameter("col_amt"));	
	String from_page = request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	if(rent_dt.equals("")) rent_dt 		= AddUtil.getDate(4);
	
	String jg_b_dt = "";
	
	
	//견적변수 기준일자 가져요기
	jg_b_dt = e_db.getVar_b_dt(cm_bean.getJg_code(), "jg", rent_dt);
	
	
	//CAR_NM : 차명정보
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//중고차잔가변수
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--

	var dlv_tns_commi = 0;
	
	function getShCarAmt(){	
		var fm = document.form1;
		var i =0;
		
		//차량가격
		var o_1 = <%=car_amt+opt_amt+col_amt%>;
		fm.nm[i].value = "차량가격(소비자가)";				fm.value[i].value = parseDecimal(o_1);		i++;
		
		//실적이관권장수당 1%
		var o_2 = 0.01;
		if(<%=ej_bean.getJg_x()%> ==0)	o_2 = 0;
		fm.nm[i].value = "실적이관권장수당율";				fm.value[i].value = o_2;			i++;
				
		//실적이관권장수당
		var o_3 = th_round(o_1*o_2);
		dlv_tns_commi = o_3;
		fm.nm[i].value = "실적이관권장수당";				fm.value[i].value = parseDecimal(o_3);		i++;

				
	}
	
	function save(){
		var ofm = opener.document.form1;
		var fm = document.form1;
		ofm.dlv_tns_commi.value = parseDecimal(dlv_tns_commi);
		self.close();
	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>실적이관권장수당 계산</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td width="10%" class=title>연번</td>
                    <td width="50%" class=title>항목</td>
                    <td width="40%" class=title>값</td>
                </tr>
        		  <%for(int i=0; i<3; i++){%>
                <tr>
        	    <td align="center"><%=i+1%></td>                    
                    <td align="center"><input type="text" name="nm" value="" size="30" class=whitetext></td>
                    <td align="center"><input type="text" name="value" value="" size="12" class=whitenum></td>          
                </tr>
        	    <%}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"> 
         	<%if(from_page.equals("/fms2/commi/commi_pay_s_frame.jsp")){%>
         		<a href="javascript:save();"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         	<%}%>
        
			<a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>  
      	
</table>	
</form>	
<script>
<!--
	getShCarAmt();	
//-->
</script>	
</body>
</html>