<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*, acar.ext.*, acar.fee.*, acar.car_accident.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rtype = request.getParameter("rtype")==null?"":request.getParameter("rtype");
	String rent="";
	int total_su = 0;
	long total_amt = 0;	
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
		
	//해지정산 리스트
	Vector clss = ae_db.getClsFeeScdList(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, rtype);
	int cls_size = clss.size();
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">
</head>
<body>
<form name="form1" id="form1" action="" method="post" target="d_content">
<input type="hidden" name="height" id="height" value="<%=height%>">
<input type="hidden" name="fee_size" value="<%=cls_size%>">

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 460px;">
					<div style="width: 460px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
								<td class="title title_border" style="width: 40px;">연번</td>
			                    <td class="title title_border" style="width: 40px;">채권</td>
			                    <td class="title title_border" style="width: 80px;">구분</td>
			        		    <td class="title title_border" style="width: 100px;">계약번호</td>
			        		    <td class="title title_border" style="width: 120px;">상호</td>
			        		    <td class="title title_border" style="width: 80px;">차량번호</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							<tr>
								<td class="title title_border" style="width: 150px;">차명</td>
								<td class="title title_border" style="width: 80px;">해지일자</td>
								<td class="title title_border" style="width: 80px;">해지구분</td>
								<td class="title title_border" style="width: 60px;">항목구분</td>
								<td class="title title_border" style="width: 80px;">입금예정일</td>
								<td class="title title_border" style="width: 50px;">회차</td>
								<td class="title title_border" style="width: 100px;">금액</td>
								<td class="title title_border" style="width: 80px;">수금일자</td>
								<td class="title title_border" style="width: 70px;">연체일수</td>
								<td class="title title_border" style="width: 90px;">보증보험</td>
								<td class="title title_border" style="width: 90px;">입금액</td>
								<td class="title title_border" style="width: 90px;">입금일자</td>
								<td class="title title_border" style="width: 60px;">영업담당</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 460px;">
					<div style="width: 460px;">
						<table class="inner_top_table left_fix">
						<%if (cls_size > 0) {%>
	     					<%for (int i = 0 ; i < cls_size ; i++) {
								Hashtable cls = (Hashtable)clss.elementAt(i);
								//연체료 셋팅
								boolean flag = ae_db.calDelay((String)cls.get("RENT_MNG_ID"), (String)cls.get("RENT_L_CD"));
							%>
							 <tr style="height: 25px;">
								<td class="content_border center" style="width: 40px;">
									<!-- <a href="javascript:parent.view_memo3('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"> -->
									<%=i+1%>
									<!-- </a> -->
								</td>
			                    <td class="content_border center" style="width: 40px;">
			                    	<a href="javascript:parent.view_memo('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>','9','<%=cls.get("CR_GUBUN")%>','','')" onMouseOver="window.status=''; return true"><%=cls.get("CR_GUBUN")%></a>
			                    </td>
			                    <td class="content_border center" style="width: 80px;">
		                    	<%if (String.valueOf(cls.get("CLS_GUBUN")).trim().equals("정산금")) {%>
			                    	<a href="javascript:parent.view_memo('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>','4','','','<%=cls.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title="<%=a_cad.getMaxMemo(String.valueOf(cls.get("RENT_MNG_ID")), String.valueOf(cls.get("RENT_L_CD")), "4", "", "")%>">
			                    	<%if (String.valueOf(cls.get("CLS_ST")).trim().equals("14")) {%>
			                    		<font color='red'>(월)</font><%=cls.get("GUBUN")%>
			                    	<%} else {%>
			                    		<%=cls.get("GUBUN")%>
			                    	<%}%>
			                    	</a>
			                    <%} else {%>
			                   		<a href="javascript:parent.view_memo2('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','1','<%=cls.get("TM")%>','0','<%=cls.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title="<%=af_db.getMaxMemo(String.valueOf(cls.get("RENT_MNG_ID")), String.valueOf(cls.get("RENT_L_CD")), "")%>"><font color='red'><%=cls.get("GUBUN")%></font></a>
			                    <%}%>
			                    </td>
			        		    <td class="content_border center" style="width: 100px;"><a href="javascript:parent.view_cls('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=cls.get("RENT_L_CD")%></a></td>
			        		    <td class="content_border center" style="width: 120px;"><span title='<%=cls.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(cls.get("FIRM_NM")), 7)%></a></span></td>
			        		    <td class="content_border center" style="width: 80px;">
			        		    	<span title='<%=cls.get("CAR_NO")%>'>
				                    <%if (String.valueOf(cls.get("PREPARE")).equals("9") || String.valueOf(cls.get("PREPARE")).equals("4")) {%>
				                  		<font color="green"><%=Util.subData(String.valueOf(cls.get("CAR_NO")), 15)%></font>
				                    <% } else {%>
				                    	<%=Util.subData(String.valueOf(cls.get("CAR_NO")), 15)%>
				                    <%}%> 
				                    </span>
			        		    </td>	
							</tr>
							<%}%>
							<tr> 
			        			<td class="title content_border center" colspan="6">합계</td>
			                </tr>
						<%} else {%>  
						   	<tr>
						        <td colspan="6" class="content_border center">등록된 데이타가 없습니다</td>
						    </tr>
					 	<%}%>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout">
						<%if (cls_size > 0) {%>
		          			<%for (int i = 0; i < cls_size; i++) {
					 			Hashtable cls = (Hashtable)clss.elementAt(i);
					 		%>
							 <tr style="height: 25px;">
								<td class="content_border center" style="width: 150px;">
								<%if (String.valueOf(cls.get("PREPARE")).equals("9") || String.valueOf(cls.get("PREPARE")).equals("4")) {%>
		                    		<font color=red>(<%if(String.valueOf(cls.get("PREPARE")).equals("9")){%>미회수<%}else if(String.valueOf(cls.get("PREPARE")).equals("4")){%>말소<%}%>)</font>
		                    		<span title='<%=cls.get("CAR_NM")%> <%=cls.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(cls.get("CAR_NM"))+" "+String.valueOf(cls.get("CAR_NAME")), 6)%></span>
		                    	<%} else {%>
		                    		<span title='<%=cls.get("CAR_NM")%> <%=cls.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(cls.get("CAR_NM"))+" "+String.valueOf(cls.get("CAR_NAME")), 9)%></span>
		                    	<%}%>
								</td>
								<td class="content_border center" style="width: 80px;"><%=AddUtil.ChangeDate2(String.valueOf(cls.get("CLS_DT")))%></td>
								<td class="content_border center" style="width: 80px;"><%=cls.get("CLS_ST_NM")%></td>
								<td class="content_border center" style="width: 60px;"><%=cls.get("CLS_GUBUN")%></td>
								<td class="content_border center" style="width: 80px;"><%=AddUtil.ChangeDate2(String.valueOf(cls.get("EST_DT")))%></td>
								<td class="content_border center" style="width: 50px;"><%=cls.get("TM")%><%=cls.get("TM_ST")%></td>
								<td class="content_border right" style="width: 100px;"><%=Util.parseDecimal(String.valueOf(cls.get("AMT")))%></td>
								<td class="content_border center" style="width: 80px;"><%=AddUtil.ChangeDate2(String.valueOf(cls.get("PAY_DT")))%></td>
								<td class="content_border right" style="width: 70px;"><%=cls.get("DLY_DAYS")%>일</td>
								<td class="content_border right" style="width: 90px;"><%=Util.parseDecimal(String.valueOf(cls.get("GI_AMT")))%></td>
								<td class="content_border right" style="width: 90px;"><%=Util.parseDecimal(String.valueOf(cls.get("PAY_AMT2")))%></td>
								<td class="content_border center" style="width: 90px;"><%=AddUtil.ChangeDate2(String.valueOf(cls.get("PAY_DT2")))%></td>
								<td class="content_border center" style="width: 60px;"><%=c_db.getNameById(String.valueOf(cls.get("BUS_ID2")), "USER")%></td>
							</tr>
							<%
								total_su = total_su + 1;
								total_amt = total_amt + AddUtil.parseLong(String.valueOf(cls.get("AMT")));
							%>
							<%}%>
			                <tr>
			                    <td class="title content_border">&nbsp;</td>
			                    <td class="title content_border">&nbsp;</td>
			                    <td class="title content_border">&nbsp;</td>
			                    <td class="title content_border">&nbsp;</td>
			                    <td class="title content_border">&nbsp;</td>
			                    <td class="title content_border">&nbsp;</td>
			                    <td class="title content_border right"><%=Util.parseDecimal(total_amt)%></td>
			                    <td class="title content_border">&nbsp;</td>
			                    <td class="title content_border">&nbsp;</td>
			                    <td class="title content_border">&nbsp;</td>
								<td class="title content_border">&nbsp;</td>
								<td class="title content_border">&nbsp;</td>
			                    <td class="title content_border">&nbsp;</td>
			                </tr>
						<%} else {%>
					       <tr>
						        <td colspan="13" class="content_border center">&nbsp;</td>
						   </tr>
			   			<%}%>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
</form>	            

</body>
</html>
