<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");

	//카드 일일현황 영업소 조회
	Vector vt2 = oc_db.getCarCashBackDayCd(s_yy);
	int vt_size2 = vt2.size();
	String car_off_ids[] = new String[vt_size2];
	if(vt_size2 > 0){
		for (int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht = (Hashtable)vt2.elementAt(i);
			car_off_ids[i] = String.valueOf(ht.get("CAR_OFF_ID"));		
		}
	}
	
	//카드 일일현황 조회
	Vector vt = oc_db.getCarCashBackDayStat(s_yy, s_mm, car_off_ids);
	int vt_size = vt.size();
	
	long total_amt[]	 = new long[vt_size2+1];
	
	if(vt_size > 0){
		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			total_amt[0] = total_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("AMT0")));
			for (int i2 = 0 ; i2 < vt_size2 ; i2++){
				total_amt[i2+1] = total_amt[i2+1] + AddUtil.parseLong(String.valueOf(ht.get("AMT"+(i2+1))));
			}
		}
	}
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function Search(){
		var fm = document.form1;
		//if(fm.s_yy.value == '2019' && toInt(fm.s_mm.value) < 6){
		//	alert('2019년6월 이전 데이타는 없습니다.'); return;
		//}
		fm.action = "car_cash_back_day_sc.jsp";
		fm.target = "_self";
		fm.submit();
  }
  
  function CarStatBase(base_dt, car_off_id){
		var fm = document.form1;
		fm.base_dt.value = base_dt;
		fm.car_off_id.value = car_off_id;
		fm.action = "car_cash_back_day_list.jsp";
		window.open("about:blank", "CarDayList", "left=350, top=50, width=1000, height=800, scrollbars=yes, status=yes");
		fm.target = "CarDayList";
		fm.submit();
  }
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='car_cash_back_day_sc.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='base_dt' value=''>
<input type='hidden' name='car_off_id' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1580>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>일일현황</span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
						<select name="s_yy">
			  			<%for(int i=2019; i<=AddUtil.getDate2(1); i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>
	        			<select name="s_mm">
	          			<%for(int i=1; i<=12; i++){%>
	          				<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
	          			<%}%>
	        			</select>             			  
            			  &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					</td>
                </tr>
            </table>
        </td>
    </tr>	  
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='6%' class='title'>출고일자</td>
                    <%for (int i2 = 0 ; i2 < vt_size2 ; i2++){ 
                    		String car_off_nm = c_db.getNameById(car_off_ids[i2],"CAR_OFF");
                    %>
                    <td width='<%=86/vt_size2%>%' class='title'><span title='<%=car_off_nm%>'><%=Util.subData(car_off_nm, 6)%></span></td>
                    <%} %>
                    <td width='8%' class='title'>합계</td>
                </tr>

                <%if(vt_size > 0){
				        for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
                <tr>
                    <td class='title'><%=ht.get("DAY")%></td>
                    <%for (int i2 = 0 ; i2 < vt_size2 ; i2++){ %>    
                    <td align="right"><a href="javascript:CarStatBase('<%=ht.get("BASE_DT")%>', '<%=ht.get("CAR_OFF_ID"+(i2+1))%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT"+(i2+1))))%></a></td>
                    <%} %>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT0")))%></td>
                </tr>
		        <%		}%>
		            
                <tr>
                    <td class='title'>합계</td>
                    <%for (int i2 = 0 ; i2 < vt_size2 ; i2++){ %>                    
                    <td align="right"><a href="javascript:CarStatBase('', '<%=car_off_ids[i2]%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt[i2+1])%></td>
                    <%} %>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt[0])%></td>
                </tr>		            
		        <%}else{%>
                <tr>
                    <td colspan="<%=vt_size2+2 %>" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		        <%}%>
            </table>
	    </td>
    </tr>

  </table>
</form>
</body>
</html>
