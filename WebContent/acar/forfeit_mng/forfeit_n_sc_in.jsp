<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");

	int total_su = 0;
	long total_amt = 0;
		
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	
	Vector vt = afm_db.getFineCollNoPayStatList(gubun1, gubun2, s_kd, t_wd, sort_gubun, asc);
	int vt_size = vt.size();
		
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language='javascript'>
<!--

//-->
</script>
<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type="hidden" name="height" id="height" value="<%=height%>">
<input type='hidden' name='fee_size' value='<%=vt_size%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 360px;">
					<div style="width: 360px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							    <td width="11%" rowspan="2" class='title title_border'>연번</td>
			        			<td width="39%" rowspan="2" class='title title_border'>청구기관</td>				
			        			<td width="26%" rowspan="2" class='title title_border'>차량번호</td>
			        			<td width="24%" rowspan="2" class='title title_border'>차명</td>
        			
							</tr>
						</table>
					</div>
				</td>
				<td style="width: 1800px;">
					<div style="width: 1800px;">
						<table class="inner_top_table table_layout" style="height: 60px;">
							  <colgroup>
				       			<col width="4%">
				       			<col width="9%">
				       			<col width="5%">
				       			<col width="5%">	       			
				       			<col width="5%"> 	
				       			<col width="4%">	       			
				       			<col width="4%">
				       			<col width="3%">
				       			<col width="3%">
				       			<col width="3%">
				       			<col width="3%">
				       			<col width="3%">
				       			<col width="3%">
				       			
				       			<col width="6%">
				       			<col width="5%">
				       			<col width="5%">
				       			<col width="4%">
				       			<col width="6%">
				       			<col width="4%">
				       			<col width="4%"> <!-- 단기대여 -->				
				       			
				       			<col width="3%">
				       			<col width="3%">
				       			<col width="3%">				       			
				       		</colgroup>
				       									
							  <tr> 
			        			<td width="4%" rowspan="2" class='title title_border'>위반일자</td>
			        			<td width="9%" rowspan="2" class='title title_border'>위반장소</td>
			        			<td width="5%" rowspan="2" class='title title_border'>위반내용</td>
			        			<td width="5%" rowspan="2" class='title title_border'>납부방식</td>
			        			<td width="5%" rowspan="2" class='title title_border'>고지서접수일</td>
			        			<td width="4%" rowspan="2" class='title title_border'>납부기한</td>
			        			<td width="4%" rowspan="2" class='title title_border'>수금일자</td>		  
			        			<td width="3%" rowspan="2" class='title title_border'>금액</td>		  					
			        			<td width="3%" rowspan="2" class='title title_border'>업무과실</td>
			        			<td width="3%" rowspan="2" class='title title_border'>담당자</td>			
			        			<td width="3%" rowspan="2" class='title title_border'>매각<br>구분</td>
			        			<td width="3%" rowspan="2" class='title title_border'>대여<br>구분</td>
			        			<td width="3%" rowspan="2" class='title title_border'>계약<br>구분</td>
			        			
			        			<td colspan="3"  width="16%" class='title title_border'>장기대여</td>
			        			<td colspan="4"  width="18%" class='title title_border'>단기대여</td>																																
			        			<td width="3%" rowspan="2" class='title title_border'>최초영업</td>
			        			<td width="3%" rowspan="2" class='title title_border'>영업담당</td>
			        			<td width="3%" rowspan="2" class='title title_border'>관리담당</td>
			                </tr>
			    		    <tr>
			        			<td width="6%" class='title title_border'>고객</td>
			        		    <td width="5%" class='title title_border'>대여개시일</td>
			        		    <td width="5%" class='title title_border'>대여만료일</td>
			        			<td width="4%" class='title title_border'>구분</td>
			        			<td width="6%" class='title title_border'>사용자</td>
			        			<td width="4%" class='title title_border'>배차일</td>
			        			<td width="4%" class='title title_border'>반차일</td>
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
				<td style="width: 360px;">
					<div style="width: 360px;">
						<table class="inner_top_table left_fix">  
			              <%for(int i = 0 ; i < vt_size ; i++){
			    					Hashtable ht = (Hashtable)vt.elementAt(i);%>	
			                <tr> 
			        			<td width="11%" class="center content_border"><%=i+1%></td>
			        			<td width="39%" class="center content_border"><span title='<%=ht.get("GOV_NM")%>'><%=Util.subData(String.valueOf(ht.get("GOV_NM")), 10)%></span></td>				
			        			<td width="26%" class="center content_border"><a href="javascript:parent.view_forfeit('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("SEQ_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_NO")%></a></td>
			        			<td width="24%" class="center content_border"><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
			                </tr>
			              <%		}%>
			                <tr> 
			                    <td colspan="4" class="title content_border">&nbsp;</td>
			                </tr>						  
			            </table>
			          </div>  
		        </td>
		        <td style="width: 1800px;">
					<div style="width: 1800px;">
						<table class="inner_top_table table_layout">
						
			              <%for(int i = 0 ; i < vt_size ; i++){
			    				Hashtable ht = (Hashtable)vt.elementAt(i);%>	
			                <tr> 
			        			<td width="4%" class="center content_border"><%=ht.get("VIO_DT")%></td>
			        		    <td width="9%" class="center content_border"><span title='<%=ht.get("VIO_PLA")%>'><%=Util.subData(String.valueOf(ht.get("VIO_PLA")), 9)%></span></td>
			        		    <td width="5%" class="center content_border"><span title='<%=ht.get("VIO_CONT")%>'><%=Util.subData(String.valueOf(ht.get("VIO_CONT")), 5)%></span></td>
			        		    <td width="5%" class="center content_border"><%=ht.get("PAID_ST")%></td>
			        		    <td width="5%" class="center content_border"><%=ht.get("REC_DT")%></td>
			        		    <td width="4%" class="center content_border"><%=ht.get("PAID_END_DT")%></td>
			        		    <td width="4%" class="center content_border"><%=ht.get("COLL_DT")%></td>	
			        		    <td width="3%" class="right content_border"><%=Util.parseDecimal(String.valueOf(ht.get("PAID_AMT")))%></td>						
			        			<td width="3%" class="center content_border"><%=ht.get("FAULT_NM")%></td>				  
			        			<td width="3%" class="center content_border"><%=ht.get("FINE_MNG_NM")%></td>				  			
			        			<td width="3%" class="center content_border"><%=ht.get("SUI_ST")%></td>
			        			<td width="3%" class="center content_border"><%=ht.get("USE_ST")%></td>
			        			<td width="3%" class="center content_border"><%=ht.get("CAR_ST")%></td>
			        			<td width="6%" class="center content_border"><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
			        			<td width="5%" class="center content_border"><%=ht.get("MIN_DT")%></td>
			        			<td width="5%" class="center content_border"><%=ht.get("MAX_DT")%></td>
			        			<td width="4%" class="center content_border"><%=ht.get("RENT_ST")%></td>
			        			<td width="6%" class="center content_border"><span title='<%=ht.get("CUST_NM")%>'><%=Util.subData(String.valueOf(ht.get("CUST_NM")), 6)%></span></td>
			        			<td width="4%" class="center content_border"><%=ht.get("DELI_DT")%></td>
			        			<td width="4%" class="center content_border"><%=ht.get("RET_DT")%></td>
			        			<td width="3%" class="center content_border"><%=ht.get("BUS_NM")%></td>
			        			<td width="3%" class="center content_border"><%=ht.get("BUS_NM2")%></td>
			        			<td width="3%" class="center content_border"><%=ht.get("MNG_NM")%></td>
			                </tr>
			              <%	total_amt = total_amt  + Long.parseLong(String.valueOf(ht.get("PAID_AMT")));
			    		}%>
			                <tr> 
			                    <td colspan="6" class="title content_border">&nbsp;</td>
			                    <td colspan="2" class="title content_border right"><%=Util.parseDecimal(total_amt)%></td>		
			                    <td colspan="15" class="title content_border">&nbsp;</td>
			                  	
			                </tr>			
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
