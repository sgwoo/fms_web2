<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_car_cost_excel.xls");
%>

<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.cont.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = "";
		
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	
	String gubun 	= request.getParameter("gubun")==null?"jg_code":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String sort 	= request.getParameter("sort")==null?"5":request.getParameter("sort");
	String car_ck 	= request.getParameter("car_ck")==null?"":request.getParameter("car_ck");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");	
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String chk1 	= request.getParameter("chk1")==null?"":request.getParameter("chk1");
	
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	//Vector vt = ad_db.getServAllCost(ref_dt1, ref_dt2, gubun, gubun_nm, gubun3, gubun4,  sort, car_ck);
	Vector vt = ad_db.getServAllCost(ref_dt1, ref_dt2, gubun, gubun_nm, gubun3, gubun4, chk1, sort, car_ck);
	
	int vt_size = vt.size();
	
	long t_d1[] = new long[1];
	long t_d2[] = new long[1];
	
	float a_dis= 0;
 	 	
 	  //누적개월수 
 	float umon_cnt= 0;
 	float t_umon_cnt= 0;
 	
    long t_amt17[] = new long[1];
    long t_amt18[] = new long[1];
    
    long t_amt[]	 		= new long[16];
   
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

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 695px;">
					<div style="width: 695px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>						
		        		    	<td width='40' class='title title_border' >연번</td>					
								<td width='120' class='title title_border'> 상호</td>
								<td width='120'  class='title title_border'> 종목</td>	
								<td width='150' class='title title_border'>차종</td>				
								<td width='70' class='title title_border'>연료</td>					
								<td width='75' class='title title_border'>대여<br>개시일</td>	
						 	    <td width='65' class='title title_border'>이용<br>개월</td>	
								<td width='55' class='title title_border'>관리<br>구분</td>	
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
						   <colgroup>		              
				       			<col width="100">
				       			<col width="100">
				       			
				       			<col width="90">
				       			<col width="90">	
				       			<col width="90">	
				       			<col width="90">	
				       			<col width="90">	
				       			<col width="90">		       			
				       			<col width="90">		       			
				       			<col width="90">
				       			
				       			<col width="90">
				       			<col width="90">	
				       			<col width="90">	
				       			<col width="90">	
				       			<col width="90">	
				       			<col width="90">		       			
				       			<col width="90">		       			
				       			<col width="90">
				       			
				       			<col width="90">	<!--  계약번호 -->		
				       			<col width="75">	
				       			<col width="65">	
				       			<col width="65">	
				       			<col width="65">	
				       			<col width="75">	<!-- 계약일 -->	       			
				       			<col width="70"> 
				       			<col width="90">
				       			<col width="60">
				       			<col width="75">	
				       			<col width="35">	
				       			<col width="60">	
				       			<col width="60">	
				       			<col width="55">		       			
				       			<col width="120">	
				       			<col width="60">	
				       			<col width="80">	  <!-- 소비자기격 -->
				       			<col width="60">
			       		    </colgroup>
				       	       		
							<tr>
				        		<td  rowspan=2  class='title title_border'>누적<br>총비용</td>
						       	<td  rowspan=2  class='title title_border'>월평균<br>총비용</td>
								<td class='title title_border' colspan=8>누적비용 내역</td>
								<td  class='title title_border' colspan=8>월평균비용 내역</td>	
								<td   rowspan=2 class='title title_border'>계약번호</td>
								<td  rowspan=2 class='title title_border' >최초<br>등록일</td>	
								<td  rowspan=2 class='title title_border'>현재<br>주행거리</td>
								<td   rowspan=2 class='title title_border'>연평균<br>주행거리</td>		
								<td   rowspan=2 class='title title_border'>약정<br>주행거리</td>						
								<td  rowspan=2 class='title title_border'>계약일</td>	
								<td   rowspan=2 class='title title_border'> 관리<br>담당자</td>	
								<td   rowspan=2 class='title title_border'> 차량번호</td>	
								<td   rowspan=2 class='title title_border'> 용도<br>구분</td>	
								<td   rowspan=2 class='title title_border'>정비일</td>		
								<td   rowspan=2 class='title title_border'>차종<br>코드</td>	
								<td  rowspan=2 class='title title_border'>계약<br>구분</td>			
								<td   rowspan=2 class='title title_border'>신차<br>구분</td>			
								<td  rowspan=2 class='title title_border'>기타<br>구분</td>							
								<td  rowspan=2 class='title title_border'>이용<br>지역</td>	
								<td  rowspan=2 class='title title_border'>첨단사양<br>할인율(%)</td>		
								<td  rowspan=2 class='title title_border'>소비자가격</td>	
								<td  rowspan=2 class='title title_border'>신용등급</td>													
							</tr>
							<tr>
								<td width='90' class='title title_border'>정비비</td>
								<td width='90' class='title title_border'>정비대차</td>	
								<td width='90' class='title title_border'>대차입금</td>
								<td width='90' class='title title_border'>사고수리비</td>
								<td width='90' class='title title_border'>면책금</td>							
								<td width='90' class='title title_border'>사고대차</td>
								<td width='90' class='title title_border'>대차료입금</td>	
								<td width='90' class='title title_border'>기타</td>
								
								<td width='90' class='title title_border'>정비비</td> <!-- 월평균 -->
								<td width='90' class='title title_border'>정비대차</td>	
								<td width='90' class='title title_border'>대차입금</td>
								<td width='90' class='title title_border'>사고수리비</td>
								<td width='90' class='title title_border'>면책금</td>							
								<td width='90' class='title title_border'>사고대차</td>
								<td width='90' class='title title_border'>대차료입금</td>	
								<td width='90' class='title title_border'>기타</td>												
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
				<td style="width: 695px;">
					<div style="width: 695px;">
						<table class="inner_top_table left_fix">
				     <%  if(vt_size > 0)	{  %>				
							<% 
								for(int i = 0 ; i < vt_size ; i++)
								{
									Hashtable ht = (Hashtable)vt.elementAt(i);
									a_dis =   AddUtil.parseFloat(String.valueOf(ht.get("SS")));
									
									if ( chk1.equals("1")  ){					
										umon_cnt =  AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ht.get("UMON1"))),2);
									//	t_umon_cnt += AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ht.get("UMON1"))),1);
										
									} else {
										umon_cnt =  AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ht.get("UMON"))),2);
									//	t_umon_cnt +=  AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ht.get("UMON"))),1);
									}
														
								   if (umon_cnt < 0) umon_cnt = 0;
								   t_umon_cnt += umon_cnt;	
							%>			
			  	            
							<tr>					
								<td  width='40' class='center content_border'><%=i+1%></td>	
								<td  width='120' class='center content_border'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>		
								<td  width='120' class='center content_border'>&nbsp;<span title='<%=ht.get("BUS_ITM")%>'><%=Util.subData(String.valueOf(ht.get("BUS_ITM")), 8)%></span></td>			
								<td  width='150' class='center content_border'>&nbsp;<%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 10)%></td>		
								<td  width='70' class='center content_border'>&nbsp;<%=Util.subData(String.valueOf(ht.get("FUEL_NM")), 5)%></td>													
								<td  width='75' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
								<td  width='65' class='center content_border'><%= AddUtil.parseFloatCipher(umon_cnt,2)%></td>
								<td  width='55' class='center content_border'><%  if ( String.valueOf(ht.get("CAR_ST")).equals("5") ) { %>업무대여 <% } else {%><%=ht.get("RENT_WAY_NM")%><% } %></td>															
							</tr>
			         	<%      } %>
			      	  		<tr>
								<td class='title content_border ' colspan=6 > 합계 </td>	
								<td  class='title content_border right'  width='65'>
								<%  t_umon_cnt =  AddUtil.parseFloatCipher(t_umon_cnt,2); %>
								<%= t_umon_cnt%></td>	
								<td   class='title content_border'  width='55' ></td>											
							</tr>
							<tr>
								<td class='title content_border' colspan=6 > 평균 </td>	
								<td class='title content_border right'  width='65' ><%= Util.parseDecimal(t_umon_cnt/vt_size)%></td>							   
								<td class='title content_border'  width='55' ></td>
							
							</tr>		
			    <%} else  {%>  
			              	<tr>
					            <td class='center content_border'>등록된 데이타가 없습니다</td>
					        </tr>	              
				 <%}	%>
			            </table>
			         </div>
			     </td>
	    		 <td>
	    			 <div>
						<table class="inner_top_table table_layout">
		<%  if(vt_size > 0)	{  %>
				<%
						for(int i = 0 ; i < vt_size ; i++)
						{
							Hashtable ht = (Hashtable)vt.elementAt(i);		%>				
			 		  		<tr>						
								<td  width='100' class='right content_border'><%=  Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT17"))))%></td>
								<td  width='100' class='right content_border'><%=  Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT18"))))%></td>
								
							 <%	for (int j = 0 ; j < 16 ; j++){%>					       
					            <td class="right content_border" width='90'><%= Util.parseDecimal(AddUtil.parseLong((String)ht.get("AMT"+(j+1))))%></td>
							 <%	}%>
								 
								<td  width='90' class='center content_border '><%=ht.get("RENT_L_CD")%></td>	
								<td  width='75' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>	
								<td  width='65' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%></td>
								<td  width='65' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("Y_AVE_DIST")))%></td>		
								<td  width='65' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGREE_DIST")))%></td>										
								<td  width='75' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>								
								<td  width='70' class='center content_border'><%=ht.get("MNG_NM")%></td>
								<td  width='90' class='center content_border'><span title='<%=ht.get("CAR_MNG_ID")%>'><%=ht.get("CAR_NO")%></span></td>	
								<td  width='60' class='center content_border'>
								<% if ( String.valueOf(ht.get("CAR_USE")).equals("1") ) { %>렌트<%} else { %>리스<%} %>					
								</td>	
								<td  width='75' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TOT_DT")))%></td>		
								<td  width='35' class='center content_border'><%=ht.get("JG_CODE")%></td>	
								<td  width='60' class='center content_border'><%=ht.get("RENT_ST_NM")%></td>	
								<td  width='60' class='center content_border'><%=ht.get("CAR_GU_NM")%></td>		
								<td  width='55' class='center content_border'><%=ht.get("ETC_GU_NM")%></td>								
								<td  width='120' class='center content_border'>								
					<%  //계약기타정보
								ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));								
					%>							
	                         <%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
								</td>
								<td  width='60' class='center content_border'>	<%=AddUtil.parseFloat(String.valueOf(ht.get("RATE")))* 100%></td>	
								<td  width='80' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td>		
								<td  width='60' class='center content_border'>	<%=ht.get("KCB")%></td>																		
							</tr>
			          <%
					            for (int j = 0 ; j < 16 ; j++){
									
									t_amt[j] +=  AddUtil.parseLong((String)ht.get("AMT"+(j+1)));
								}
			          
						          t_amt17[0] +=  AddUtil.parseLong((String)ht.get("AMT17"));
						          t_amt18[0] +=  AddUtil.parseLong((String)ht.get("AMT18"));
			          
			           } %> 	
		       				  <tr>
		         				<td class='title content_border' style="text-align:right; font-size=8pt"><%=Util.parseDecimal(t_amt17[0])%></td>
								<td class='title content_border' style="text-align:right; font-size=8pt"></td>
							 <%	for (int j = 0 ; j < 8 ; j++){%>					       
						        <td class='title content_border' style="text-align:right; font-size=8pt"><%= Util.parseDecimal(t_amt[j])%></td>
							 <%	}%>	
								<td class='title content_border' style="text-align:right; font-size=8pt"></td>
								<td class='title content_border' style style="text-align:right; font-size=8pt"></td>
								<td class='title content_border' style="text-align:right; font-size=8pt"></td>
								<td class='title content_border' style="text-align:right; font-size=8pt"></td>	
								<td class='title content_border' style="text-align:right; font-size=8pt"></td>
								<td class='title content_border' style="text-align:right; font-size=8pt"></td>
								<td class='title content_border' style="text-align:right; font-size=8pt"></td>
								<td class='title content_border' style="text-align:right; font-size=8pt"></td>	
								<td   class='title content_border' width='90' ></td>		
								<td   class='title content_border' width='75' ></td>			
								<td   class='title content_border' width='65' ></td>			
								<td   class='title content_border' width='65' ></td>	
								<td   class='title content_border' width='65' ></td>										
								<td   class='title content_border' width='75' ></td>							
								<td   class='title content_border' width='70' ></td>
								<td   class='title content_border' width='90' ></td>	
								<td   class='title content_border' width='60' ></td>	
								<td   class='title content_border' width='75' ></td>			
								<td   class='title content_border' width='35' ></td>		
								<td   class='title content_border' width='60' ></td>
								<td   class='title content_border' width='60' ></td>	
								<td   class='title content_border' width='55' ></td>					
								<td   class='title content_border' width='120'></td>		
								<td   class='title content_border' width='60' ></td>	
								<td   class='title content_border' width='80' ></td>	
								<td   class='title content_border' width='60' ></td>																
							</tr>
						
							<tr>
								<td class='title content_border' style="text-align:right; font-size=8pt"><%=Util.parseDecimal(t_amt17[0]/vt_size)%></td>
								<td class='title content_border' style="text-align:right; font-size=8pt"><%= Util.parseDecimal2(t_amt17[0]/t_umon_cnt)%></td>
								
							 <%	for (int j = 0 ; j < 8 ; j++){%>					       
						        <td class='title content_border' style="text-align:right; font-size=8pt"><%= Util.parseDecimal(t_amt[j]/vt_size)%></td><!--누계 -->
							 <%	}%>
							 
							 <%	for (int j = 0 ; j < 8 ; j++){%>					       
						        <td class='title content_border' style="text-align:right; font-size=8pt"><%= Util.parseDecimal2(t_amt[j]/t_umon_cnt)%></td><!--월평균 -->
							 <%	}%>							
											
								<td   class='title content_border'   width='90' ></td>	
								<td   class='title content_border'   width='75' ></td>		
								<td   class='title content_border'   width='65' ></td>			
								<td   class='title content_border'   width='65' ></td>	
								<td   class='title content_border'   width='65' ></td>				
								<td   class='title content_border'   width='75' ></td>							
								<td   class='title content_border'   width='70' ></td>
								<td   class='title content_border'   width='90' ></td>	
								<td   class='title content_border'   width='60' ></td>	
								<td   class='title content_border'   width='75' ></td>				
								<td   class='title content_border'   width='35' ></td>	
								<td   class='title content_border'   width='60' ></td>			
								<td   class='title content_border'   width='60' ></td>		
								<td   class='title content_border'   width='55' ></td>			
								<td   class='title content_border'   width='120'></td>	
								<td   class='title content_border'   width='60' ></td>		
								<td   class='title content_border'   width='80' ></td>	
								<td   class='title content_border'   width='60' ></td>												
							</tr>
		                			
				<%} else  {%>  
				        	<tr>
						        <td width="3560" colspan="36" class='center content_border'>&nbsp;</td>
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