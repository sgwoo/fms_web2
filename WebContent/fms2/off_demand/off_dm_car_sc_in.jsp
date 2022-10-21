<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.off_demand.*,acar.common.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String dt		= request.getParameter("dt")==null?"4":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector dm_vt = dm_db.getDemandCarList1(ref_dt1,ref_dt2,dt);		
	int dm_vt_size = dm_vt.size();	
	
	Vector dm_vt2 = dm_db.getDemandCarList2(ref_dt1,ref_dt2,dt);		
	int dm_vt_size2 = dm_vt2.size();
	
	String sDate = c_db.addMonth(AddUtil.getDate(), -1);
  int kDay=0;
  kDay= AddUtil.getMonthDate(Integer.parseInt(sDate.substring(0,4)),Integer.parseInt(sDate.substring(5,7)));
	String sMonth = sDate.substring(5,7);
  sDate = sDate.substring(0,8)+kDay;

%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>

</script>
</head>
<body onLoad="javascript:init()">
<form name="form1">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">

<table border=0 cellspacing=0 cellpadding=0 width="1030">
	<tr>
		<td>○ 차량구입 및 매각 내역<%
			for(int k=0;k<=87;k++){%>
				&nbsp;
			<%}%>			(단위:백만원, 차량수, vat별도)
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td colspan=2 class=line2></td>

							</tr>
							
							<tr id='tr_title' style='position:relative;z-index:1'>		
								<td class='line' id='td_title' style='position:relative;' width=900> 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td  class='title' style="height:70px;" rowspan='2'>구분</td>
										<td  class='title' style="height:35px;" colspan='2'>구입</td>
										<td class='title' colspan='2'>매각</td>
										<td  class='title' rowspan='2'>비고</td>		  
									</tr>
									<tr>
										<td class='title' style="height:35px;">대수</td>
										<td class='title'>금액</td>
										<td  class='title'>대수</td>
										<td  class='title'>금액</td>		  
									</tr>
								</table>
								</td>		
							</tr>
							
							<tr>
								<td class='line' id='td_con' style='position:relative;' width=900> 
								<table border="0" cellspacing="1" cellpadding="0" width=100% >
									<%for(int k=0;k<dm_vt_size;k++){
        					  Hashtable ht = (Hashtable)dm_vt.elementAt(k);
        					  Hashtable ht2 = (Hashtable)dm_vt2.elementAt(k);
        	 					String ht_string =ht.get("FILE_NAME")+"";     	  
        					%>
									<tr> 
										<td align='center' style="height:30px;width:171px;" class="title"><%
											String sYear=ht.get("YEAR")+"";
										if(sYear.length()>5){%>
											<%=AddUtil.subDataCut(ht.get("YEAR")+"",4)%>년&nbsp;&nbsp;<%=sYear.substring(4,6)%>월
										<%}else if(sYear.length()<5){
											
											if(k==(dm_vt_size-1)&&sDate.equals(ref_dt2)){%>
												<%=ht.get("YEAR")%>년(<%=sMonth%>월 말일 기준)
											<%}else{%>
												<%=ht.get("YEAR")%>년
												<%}%>
											
										</td>
										<%}%>
										<td  align='center' width='170px'><%=AddUtil.parseDecimal(ht.get("CNT")+"")%></td>
										<td  align='center' width='171px'><%=AddUtil.parseDecimal(AddUtil.million(ht.get("S_AMT")+""))%></td>							
										<td align='center' width='170px'><%=AddUtil.parseDecimal(ht2.get("CNT")+"")%></td>							  
										<td  align='center' width='171px'><%=AddUtil.parseDecimal(AddUtil.million(ht2.get("S_AMT")+""))%></td>
										<td align='center'></td>
									</tr>
									<%}%>
								</table>
								</td>
							</tr>
							
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>