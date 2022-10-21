<%//@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  

<%@ page import="java.net.*, java.util.*, acar.util.*, acar.car_mst.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_car_col_excel.xls");
%>

<%
	
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarMstDatabase cmd = CarMstDatabase.getInstance();
	
	Vector vt = a_cmd.getCarColExcelList();
	int vt_size = vt.size();
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=1300>
    <tr>
        <td>            
            <table border=1 cellspacing=1 width=100%>
			  <tr>
			    <td width="30" rowspan="2" align="center">연번</td>
			    <td width="100" rowspan="2" align="center">제조사</td>
			    <td width="150" rowspan="2" align="center">차명</td>
			    <td width="140" rowspan="2" align="center">차종코드</td>
			    <td width="50" rowspan="2" align="center">구분</td>
			    <td width="150" rowspan="2" align="center">색상</td>
			    <td width="100" rowspan="2" align="center">조정잔가</td>		
			    <td width="100" rowspan="2" align="center">금액</td>												
			    <td width="300" rowspan="2" align="center">비고</td>
			    <td width="80" rowspan="2" align="center">사용여부</td>		
			    <td width="100" rowspan="2" align="center">등록일자</td>
			  </tr>
			  <tr>
			  </tr>
			  <%
			  String prev_comp_id = "";
			  String car_comp_nm = "";
			  String car_nm = "";
			  for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i); 
						if(i == 0) prev_comp_id = String.valueOf(ht.get("CAR_COMP_ID"));
						
						String curr_comp_id = String.valueOf(ht.get("CAR_COMP_ID"));
						
						// 자동차회사 조회
						if( i == 0 || !prev_comp_id.equals(curr_comp_id) ){ // 제조사(자동차회사)가 달라질 때만 DB에서 조회하도록.
							cc_bean = umd.getCarComp(curr_comp_id);
							car_comp_nm = cc_bean.getNm();
						}
						
						int car_cd = Integer.parseInt(String.valueOf(ht.get("CAR_CD")));
						
						// 차명 조회
						CarMstBean cm_r[] = cmd.getCarKind(curr_comp_id, car_cd);
						int cm_r_length = cm_r.length; 
						car_nm = cm_r[0].getCar_nm();
						String jg_code = "";
// 						cm_bean = cmd.getCarKind(curr_comp_id, car_cd);
// 						car_nm = cm_bean.getCar_nm();
						if(cm_r.length == 1){
							jg_code = cm_r[0].getJg_code();
						}else {
							for(int j=0; j<cm_r_length; ++j){
								
								if( j == (cm_r_length-1) ){
									jg_code += cm_r[j].getJg_code();
								} else{
									jg_code += cm_r[j].getJg_code() + ", ";  
								}
							}
						}
					%>
			  <tr>
			    <td align="center"><%=i+1%></td>
			    <td><%=car_comp_nm%></td>
			    <td><%=car_nm%></td>
			    <td align="left"><%=jg_code%></td>
			    <td><%if(String.valueOf(ht.get("COL_ST")).equals("2")){%>내장<%}else if (String.valueOf(ht.get("COL_ST")).equals("3")){%>가니쉬<%}else{%>외장<%}%></td>
			    <td><%=ht.get("CAR_C")%></td>
			    <td><%=ht.get("JG_OPT_ST")%></td>
				<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_C_P")))%>원</td>
				<td><%=ht.get("ETC")%></td>
				<td><%=ht.get("USE_YN")%></td>
				<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_C_DT")))%></td>
			  </tr>
			  <%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>