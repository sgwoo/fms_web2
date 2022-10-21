<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int total_su = 0;
	long total_amt = 0;
	long rtn_amt = 0;
	String nb_dt = request.getParameter("nb_dt")==null?"":request.getParameter("nb_dt");
	
	
	Vector taxs = t_db.getTaxPayList2(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int tax_size = taxs.size();
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
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


<form name='form1' method='post'>
<input type='hidden' name='allot_size' value='<%=tax_size%>'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 600px;">
					<div style="width: 600px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr> 
				               	<td width=50 class='title title_border' style='height:44'>연번</td>
								<td width=110 class='title title_border'>계약번호</td>
								<td width=110 class='title title_border'>상호</td>
								<td width=80 class='title title_border'>차량번호</td>
								<td width=140 class='title title_border'>차대번호</td>
			                    <td width=110 class='title title_border'>차명</td>
							</tr>
						</table>
					</div>
				</td>
				
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">				 												
							<tr> 	
			        			<td width=60 class='title title_border' style='height:44'>대여구분</td>			
			                    <td width=90 class='title title_border'>등록일자</td>
			                    <td width=90 class='title title_border'>신차<br>대여개시일</td>			
			                    <td width=90 class='title title_border'>납부사유<br>발생일자</td>			
			                    <td width=60 class='title title_border'>배기량</td>
			                    <td width=100 class='title title_border'>면세구입가<br>(반출가격)</td>
			                    <td width=80 class='title title_border'>친환경차<br>감면세액</td>
			                    <td width=80 class='title title_border'>신차<br>감면세액</td>                    
			                    <td width=60 class='title title_border'>잔가율</td>
			                    <td width=100 class='title title_border'>잔존가<br>(과세표준)</td>
			                    <td width=60 class='title title_border'>개별소비<br>세율</td>
			                    <td width=100 class='title title_border'>개별소비세</td>
			                    <td width=100 class='title title_border'>교육세</td>
			                    <td width=100 class='title title_border'>합계</td>
			                    <td width=90 class='title title_border'>납부일자</td>			
			                    <td width=90 class='title title_border'>환급금액</td>			
			                    <td width=90 class='title title_border'>환급일자</td>						
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
				<td style="width: 600px;">
					<div style="width: 600px;">
						<table class="inner_top_table left_fix">  
			
				<%	if(tax_size > 0){%>														
			            <%for(int i = 0 ; i < tax_size ; i++){
							Hashtable tax = (Hashtable)taxs.elementAt(i);%>
			                <tr> 
			                    <td width=50 class='center content_border'><%=i+1%></td>
			                    <td width=110 class='center content_border' colspan="2"><a href="javascript:parent.view_tax('<%=tax.get("RENT_MNG_ID")%>', '<%=tax.get("RENT_L_CD")%>', '<%=tax.get("CAR_MNG_ID")%>', '<%=tax.get("SEQ")%>', '', '<%=tax.get("CLS_ST")%>','<%=tax.get("TAX_COME_DT")%>')" onMouseOver="window.status=''; return true"><%=tax.get("RENT_L_CD")%></a></td>
			                    <td width=110 class='center content_border'><span title='<%=tax.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(tax.get("FIRM_NM")), 7)%></span></td>
			                    <td width=80 class='center content_border'><%=tax.get("CAR_NO")%></td>
								<td width=140 class='center content_border'><%=tax.get("CAR_NUM")%></td>
			                    <td width=110 class='center content_border'><span title='<%=tax.get("CAR_NM")%> <%=tax.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(tax.get("CAR_NM"))+" "+String.valueOf(tax.get("CAR_NAME")), 8)%></span></td>					
			                </tr>
			              <%	total_su = total_su + 1;	
			    				total_amt = total_amt + Long.parseLong(String.valueOf(tax.get("AMT")));
			    				rtn_amt  = rtn_amt + Long.parseLong(String.valueOf(tax.get("RTN_AMT")));
			      			}%>
			                <tr> 
			                    <td class='title content_border'>합계</td>
			                    <td class='title content_border'>건수</td>
			                    <td class='title content_border'><%=total_su%>건</td>
			                    <td class='title content_border'>금액</td>
			                    <td class='title content_border' colspan="2"><%=Util.parseDecimal(total_amt-rtn_amt)%>원</td>
			                    <td class='title content_border'>&nbsp;</td>					
			                </tr>
			      	<%} else  {%>  
				           	<tr>
						        <td  colspan="18"  class='center content_border'>&nbsp;</td>
						    </tr>	              
				    <%}	%>
			            </table>
			        </div>
			    </td>	
			    		    
				<td>	
					<div>
						<table class="inner_top_table table_layout">  
				<%	if(tax_size > 0){%>	
			       	   <%for(int i = 0 ; i < tax_size ; i++){
							Hashtable tax = (Hashtable)taxs.elementAt(i);%>
			                <tr> 
			                    <td width=60 class='center content_border'><%=tax.get("TAX_ST")%></td>
			                    <td width=90 class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(tax.get("INIT_REG_DT")))%></td>			
			                    <td width=90 class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(tax.get("RENT_START_DT2")))%></td>						
			                    <td width=90 class='center content_border'><%=tax.get("TAX_COME_DT")%></td>
			                    <td width=60 class='center content_border'><%=tax.get("DPM")%>CC</td>
			                    <td width=100 class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("CAR_FS_AMT")))%></td>
			                    <td width=80 class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("BK_122")))%></td>
			                    <td width=80 class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("CH_327")))%></td>
			                    <td width=60 class='center content_border'><%=tax.get("SUR_RATE")%>%</td>
			                    <td width=100 class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("SUR_AMT")))%></td>
			                    <td width=60 class='center content_border'><%=tax.get("TAX_RATE")%>%</td>
			                    <td width=100 class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("SPE_TAX_AMT")))%></td>
			                    <td width=100 class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("EDU_TAX_AMT")))%></td>
			                    <td width=100 class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("AMT")))%></td>
			                    <td width=90 class='center content_border'><%=tax.get("PAY_DT")%></td>			
			                    <td width=90 class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("RTN_AMT")))%></td>
			                    <td width=90 class='center content_border'><%=tax.get("RTN_DT")%></td>						
			                </tr>
			                <%}%>
			                <tr> 
			                    <td colspan="18" class='title content_border'>&nbsp;</td>
			                </tr>
			      	<%} else  {%>  
				           	<tr>
						        <td  colspan="18"  class='center content_border'>&nbsp;</td>
						    </tr>	              
				    <%}	%>
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
