<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "2";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	Vector vt = cdb.getRentEndCondAll(dt, ref_dt1, ref_dt2, gubun3, gubun4 );
	int vt_size = vt.size();
	
	long total_amt 	= 0;
	long total_amt2	= 0;
	
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
<form name="form1" id="form1" action="" method="post" target="d_content">
<input type="hidden" name="height" id="height" value="<%=height%>">

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 330px;">
					<div style="width: 330px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>									        		    
			        		    <td width=50 class="title title_border" >연번</td>
			        		    <td width=60 class="title title_border" >알림톡</td>
			            		<td width=100 class="title title_border">계약번호</td>
			            		<td width=120 class="title title_border">상호</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							<tr>
								<td width=60 class="title title_border">대여방식</td>
								<td width=70 class="title title_border">대여기간</td>
								<td width=60 class="title title_border">영업사원</td>								
			            		<td width=80 class="title title_border">계약개시일</td>
			            		<td width=80 class="title title_border">계약만료일</td>
			            		<td width=80 class="title title_border">스케쥴</td>
			            		<td width=100 class="title title_border">차명</td>
			            		<td width=80 class="title title_border">차량번호</td>
			            		<td width=80 class="title title_border">등록일</td>
			            		<td width=80 class="title title_border">차령만료일</td>
			            		<td width=80 class="title title_border">차령연장여부</td>
			            		<td width=60 class="title title_border">최초영업</td>
			            		<td width=60 class="title title_border">영업담당</td>		
			            		<td width=60 class="title title_border">진행</td>
			            		<td width=80 class="title title_border">진행등록일<br>(2개월이내)</td>
			            		<td width=80 class="title title_border">진행등록일<br>(2개월이상)</td>
			            		<td width=70 class="title title_border">미청구일수</td>
			            		<td width=100 class="title title_border">미청구대여료</td>
			            		<td width=100 class="title title_border">차량잔가</td>
			            		<td width=100 class="title title_border">채권반영분</td>
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
				<td style="width: 330px;">
					<div style="width: 330px;">
						<table class="inner_top_table left_fix">						
					<%	if(vt_size > 0){%>			            
			              <% for (int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);%>
            				<tr style="height: 27px;"> 
								<td class="center content_border" width=50>
								<a href="javascript:parent.view_memo_settle('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; title='계약채권메모'; return true; " ) ><%= i+1%></a></td>														 
            					<td class="center content_border" width=60><a href="javascript:parent.view_kakao_contract('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_COMP_ID")%>');" class="btn" title='알림톡'><img src=/acar/images/center/button_ntalk.gif align=absmiddle border=0></a></td>
            					<td class="center content_border" width=100><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='계약관리로 이동'><%=ht.get("RENT_L_CD")%></a></td>
            					<td class="center content_border" width=120><span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
			            	</tr>
						   <%}%>
			                <tr> 
			                    <td class="title content_border" colspan="4">합계</td>
			                </tr>
					 	<%} else {%>  
						   	<tr>
						        <td colspan="4" class="content_border center">등록된 데이타가 없습니다</td>
						    </tr>
					 	<%}%>
						</table>
					</div>
				</td>
				
				<td>
					<div>
						<table class="inner_top_table table_layout">  		            		
            	    <%	if(vt_size > 0){%>	
            		  <% for (int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							
							if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){
								total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("O_1")));
							}
							%>
							<tr style="height: 27px;"> 
								<td width=60 class="center content_border"><%if(String.valueOf(ht.get("RENT_WAY")).equals("월렌트")){%><font color='red'><%}%><%=ht.get("RENT_WAY")%><%if(String.valueOf(ht.get("RENT_WAY")).equals("월렌트")){%></font><%}%></td>
								<td width=70 class="center content_border"><%=ht.get("CON_MON")%>개월</td>
								<td width=60 class="center content_border"><%= Util.subData(String.valueOf(ht.get("EMP_NM")),3)%></td>								
								<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
			            		<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
			            		<td width=80 class="center content_border"><a href="javascript:parent.reg_im_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_NO")%>')" onMouseOver="window.status=''; return true" title='임의연장등록으로 이동'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></a></td>
			            		<td width=100 class="center content_border">
			            		<%if(String.valueOf(ht.get("FUEL_KD")).equals("8")){%>
			            		<font color=red>[전]</font><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),5) %></span>
			            		<%}else{%>
			            		<span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),6) %></span>
			            		<%}%>
			            		</td>
			            		<td width=80 class="center content_border"><a href="javascript:parent.view_car('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'><%=ht.get("CAR_NO")%></a></td>
			            		<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
			            		<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_END_DT")))%></td>
			            		<td width=80 class="center content_border"><%=ht.get("CAR_END_YN")%></td>
				                <td width=60 class="center content_border"><%=ht.get("BUS_NM")%></td>
                				<td width=60 class="center content_border"><a href="javascript:parent.req_fee_start_act('계약만료처리요청', '<%=ht.get("FIRM_NM")%> <%=ht.get("CAR_NO")%> : 3일 경과부터 채권잔가반영, 임의등록 처리필요', '<%=ht.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title='<%=ht.get("BUS_ID2")%> 영업담당자에게 계약기간 경과에 따른 처리 요청 메모/메시지/문자 발송하기'><font color=green><%=ht.get("BUS_NM2")%></font></a></td>
                				<td width=60 class="center content_border">
								<a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','','1','','','')" onMouseOver="window.status=''; title='계약진행메모'; return true; " ) >
								<%	if(String.valueOf(ht.get("RE_BUS_NM")).equals("")){%>
								<img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0>
								<%	}else{%>
								<%=ht.get("RE_BUS_NM")%>								
								<%	}%>								
								</a>
								</td>
								<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_CONT_MM_DT")))%></td>		
								<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_CONT_MM_DT2")))%></td>		
                				<td width=70 class="right content_border">
								<%	if(String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%>
								<%		if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) > 0){%>
										<%=ht.get("DLY_DAY")%>일								
								<%		}else{%>
								<%			if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >= -10){%>
										
								<%			}%>										
								<%		}%>
								<%	}%>
								</td>
                				<td width=100 class="right content_border">
								<%	if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%>
								    	<%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%>
								<%	}else{%>
								<%		if(String.valueOf(ht.get("CLS_REG_YN")).equals("Y")){%>
								        	해지등록
								<%		}else{%>
								<%			if(!String.valueOf(ht.get("CALL_IN_ST")).equals("")){%>
												차량반납
								<%			}%>
								<%		}%>
								<%	}%>								
								</td>
                				<td width=100 class="right content_border"><%if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%><%=Util.parseDecimal(String.valueOf(ht.get("O_1")))%><%}%></td>
                				<td width=100 class="right content_border"><%if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("DLY_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("O_1"))))%><%}%></td>																
			            	</tr>
					   <%}%>
			                <tr> 
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>			
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>		  
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>					
			                    <td class="title content_border center">&nbsp;</td>			
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>					
			                    <td class="title content_border center">&nbsp;</td>		  
			                    <td class="title content_border center">&nbsp;</td>		  
			                    <td class="title content_border center">&nbsp;</td>			
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>			
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>		  
			                    <td class="title content_border right" ><%=Util.parseDecimal(total_amt)%></td>
			                    <td class="title content_border right" ><%=Util.parseDecimal(total_amt2)%></td>
			                    <td class="title content_border right" ><%=Util.parseDecimal(total_amt+total_amt2)%></td>
			                </tr>
			    <%} else {%>
					       <tr>
						        <td colspan="20" class="content_border center">&nbsp;</td>
						   </tr>
			   	<%}%>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>

</body>
</html>