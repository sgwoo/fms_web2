<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int total_su = 0;
	long total_amt = 0;
	long rtn_amt = 0;
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");

	Vector taxs = t_db.getTaxMngList(gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int tax_size = taxs.size();
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

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type='hidden' name='allot_size' value='<%=tax_size%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 565px;">
					<div style="width: 565px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>                   		
				            	<td width=10% class='title title_border' style='height:44'>연번</td>
								<td width=20% class='title title_border'>계약번호</td>
								<td width=25% class='title title_border'>상호</td>
								<td width=20% class='title title_border'>차량번호</td>
			                    <td width=25% class='title title_border'>차명</td>		
							</tr>
									
						</table>
					</div>
				</td>
				<td style="width: 1320px;">
					<div style="width: 1320px;">
						<table class="inner_top_table table_layout" style="height: 60px;">													
							<tr>	
							    <td width=5% class='title title_border' style='height:44'>대여구분</td>			
			                    <td width=6% class='title title_border'>출고일자</td>
			                    <td width=8% class='title title_border'>신차<br>대여개시일</td>			
			                    <td width=8% class='title title_border'>납부사유<br>발생일자</td>			
			                    <td width=5% class='title title_border'>배기량</td>
			                    <td width=8% class='title title_border'>면세구입가</td>
			                    <td width=4% class='title title_border'>잔가율</td>
			                    <td width=8% class='title title_border'>잔존가</td>
			                    <td width=5% class='title title_border'>개별소비세율</td>
			                    <td width=7% class='title title_border'>개별소비세</td>
			                    <td width=6% class='title title_border'>교육세</td>
			                    <td width=8% class='title title_border'>합계</td>
			                    <td width=7% class='title title_border'>납부일자</td>			
			                    <td width=6% class='title title_border'>환급금액</td>			
			                    <td width=7% class='title title_border'>환급일자</td>						  		  	                 	
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
				<td style="width: 565px;">
					<div style="width: 565px;">
						<table class="inner_top_table left_fix">  
			<%	if(tax_size > 0){%>
			    <%for(int i = 0 ; i < tax_size ; i++){
							Hashtable tax = (Hashtable)taxs.elementAt(i);%>
			                <tr style="height: 25px;"> 
			                    <td width=10% class='center content_border'><%=i+1%></td>
			                    <td width=20% class='center content_border' ><a href="javascript:parent.view_tax('<%=tax.get("RENT_MNG_ID")%>', '<%=tax.get("RENT_L_CD")%>', '<%=tax.get("CAR_MNG_ID")%>', '<%=tax.get("SEQ")%>', '', '<%=tax.get("CLS_ST")%>','<%=tax.get("TAX_COME_DT")%>')" onMouseOver="window.status=''; return true"><%=tax.get("RENT_L_CD")%></a></td>
			                    <td width=25% class='center content_border'><span title='<%=tax.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(tax.get("FIRM_NM")), 8)%></span></td>
			                    <td width=20% class='center content_border'><%=tax.get("CAR_NO")%></td>
			                    <td width=25% class='center content_border'><span title='<%=tax.get("CAR_NM")%> <%=tax.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(tax.get("CAR_NM"))+" "+String.valueOf(tax.get("CAR_NAME")), 9)%></span></td>					
			                </tr>
			              <%	total_su = total_su + 1;	
			    				total_amt = total_amt + Long.parseLong(String.valueOf(tax.get("AMT")));
			    				rtn_amt  = rtn_amt + Long.parseLong(String.valueOf(tax.get("RTN_AMT")));
			      			}%>
			                <tr> 
			                    <td class='title content_border' colspan=5 >합계</td>
			                 				
			                </tr>
			        <%} else  {%>  
				              	<tr>
						            <td class='center content_border'>등록된 데이타가 없습니다</td>
						        </tr>	              
				 <%}	%>
				          </table>
				     </div>
			   </td>
			   
			   <td style="width: 1320px;">		
		      	  <div style="width: 1320px;">
					   <table class="inner_top_table table_layout">   	   
			<%	if(tax_size > 0){%>	
			            <%for(int i = 0 ; i < tax_size ; i++){
							Hashtable tax = (Hashtable)taxs.elementAt(i);%>
			                <tr style="height: 25px;">  
			                    <td width=5% class='center content_border'><%=tax.get("TAX_ST")%></td>
			                    <td width=6% class='center content_border'><%=tax.get("DLV_DT")%></td>			
			                    <td width=8% class='center content_border'><%=tax.get("RENT_START_DT")%></td>						
			                    <td width=8% class='center content_border'><%=tax.get("TAX_COME_DT")%></td>
			                    <td width=5% class='center content_border'><%=tax.get("DPM")%>CC</td>
			                    <td width=8% class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("CAR_FS_AMT")))%></td>
			                    <td width=4% class='center content_border'><%=tax.get("SUR_RATE")%>%</td>
			                    <td width=8% class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("SUR_AMT")))%></td>
			                    <td width=5% class='center content_border'><%=tax.get("TAX_RATE")%>%</td>
			                    <td width=7% class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("SPE_TAX_AMT")))%></td>
			                    <td width=6% class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("EDU_TAX_AMT")))%></td>
			                    <td width=8% class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("AMT")))%></td>
			                    <td width=7% class='center content_border'><%=tax.get("PAY_DT")%></td>			
			                    <td width=6% class='right content_border'><%=Util.parseDecimal(String.valueOf(tax.get("RTN_AMT")))%></td>
			                    <td width=7% class='center content_border'><%=tax.get("RTN_DT")%></td>						
			                </tr>
			                <%}%>
			                <tr> 
			                    <td colspan="11" class='title content_border'>&nbsp;</td>
			                    <td class='title right  content_border'><%=Util.parseDecimal(total_amt)%></td>
			                    <td class='title center content_border'></td>
			                    <td class='title right content_border'><%=Util.parseDecimal(rtn_amt)%></td>
			                    <td class='title center content_border'>&nbsp;</td>					
			                </tr>
			 <%} else  {%>  
					        <tr>
							     <td width="1320" colspan="15" class='center content_border'>&nbsp;</td>
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
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=tax_size%>';
//-->
</script>
</body>
</html>
