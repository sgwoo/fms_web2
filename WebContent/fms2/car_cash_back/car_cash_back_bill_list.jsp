<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");

	String s_car_off_id = request.getParameter("s_car_off_id")==null?"":request.getParameter("s_car_off_id");
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String st = request.getParameter("st")==null?"":request.getParameter("st");
	
	//카드스케줄 리스트 조회
	Vector vt = new Vector();
	int vt_size = 0;	
	
	vt = oc_db.getCarPayStat(st, car_off_id, s_car_off_id, s_yy, s_mm, gubun1, st_dt, end_dt);
	vt_size = vt.size();	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	
	/*
	out.println("st="+st);
	out.println("car_off_id="+car_off_id);
	out.println("s_car_off_id="+s_car_off_id);
	out.println("s_yy="+s_yy);
	out.println("s_mm="+s_mm);
	out.println("gubun1="+gubun1);
	out.println("st_dt="+st_dt);
	out.println("end_dt="+end_dt);
	*/
	
%>



<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function CarBaseUp(serial){
	var fm = document.form1;
	fm.serial.value = serial;
	fm.target = "_blank";
	fm.action = "car_cash_back_day_ui.jsp";
	fm.submit();				
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='serial' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1050>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=c_db.getNameById(car_off_id,"CAR_OFF")%> 수금현황</span></td>
	  </tr>
    <tr> 
        <td align="right">(금액단위:원)</td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>	
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' rowspan='2' class='title'>연번</td>
                    <td width='9%' rowspan='2' class='title'>출고일자</td>
                    <td width='9%' rowspan='2' class='title'>차량번호</td>
                    <td width='9%' rowspan='2' class='title'>차명</td>
                    <td width='7%' rowspan='2' class='title'>차대번호</td>
                    <td colspan='2' class='title'>판매장려금</td>
                    <td colspan='4' class='title'>입금현황</td>
                    <td width='8%' rowspan='2' class='title'>미수금액</td>
                    <td width='4%' rowspan='2' class='title'>-</td>
                </tr>
                <tr>
                    <td width='8%' class='title'>적립금</td>
                    <td width='9%' class='title'>입금예정일</td>
                    <td width='9%' class='title'>입금일</td>
                    <td width='8%' class='title'>입금금액</td>
                    <td width='6%' class='title'>손익금액</td>
                    <td width='9%' class='title'>소계</td>
                </tr>                
                <%
                	if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            
				      				if(AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT"))) < 0){
				      					ht.put("DLY_AMT","0");				      				
				      				}

						            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("BASE_AMT")));
					      			total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT")));
					      			total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
					      			total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("M_AMT")));
					      			
					      %>
                <tr>
                    <td class='title'><%=i+1%></td>
                    <td class='title'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>
                    <td align="center"><%=ht.get("CAR_NM")%></td>
                    <td align="center"><%=ht.get("CAR_NUM")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BASE_AMT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT"))))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_AMT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT")))+AddUtil.parseLong(String.valueOf(ht.get("M_AMT"))))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DLY_AMT")))%></td>
                    <td align="right"><a href="javascript:CarBaseUp('<%=ht.get("SERIAL")%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%	}%>
                <tr>
                    <td class='title' colspan='5'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right">&nbsp;</td>
                    <td align="right">&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3+total_amt5)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td align="right">&nbsp;</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="13" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
  </table>
</form>
</body>
</html>
