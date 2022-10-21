<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"3":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	if(s_kd.equals("5")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = as_db.getAccidSList(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int accid_size = accids.size();
		
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.3">

</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='accid_size' value='<%=accid_size%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  
				               <td width='80' class='title title_border'>연번</td>
			                   <td width='50' class='title title_border'>상태</td>
		                       <td width='40' class='title title_border'>사진</td>
		                       <td width='70' class='title title_border'>사고유형</td>
		                       <td width='100' class='title title_border'>계약번호</td>
		                       <td width='130' class='title title_border'>상호</td>
		                       <td width='90' class='title title_border'>차량번호</td>
                                                        		
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">																		
							<tr>
			                     <td width='150' class='title title_border'>차명</td>
                            	 <td width='150' class='title title_border'>사고일시</td>
	                             <td width='120' class='title title_border'>보험접수번호</td>
	                             <td width='150' class='title title_border'>사고장소</td>
	                             <td width='150' class='title title_border'>사고내용</td>
	                             <td width='100' class='title title_border'>접수자</td>
	                             <td width='100' class='title title_border'>등록자</td>     		  
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
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix">  
          
		   <%	if(accid_size > 0){%>    
		        <% 		for (int i = 0 ; i < accid_size ; i++){
		                			Hashtable accid = (Hashtable)accids.elementAt(i);	%>
		                 <tr style="height: 25px;"> 
		                   <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border '<%}%> width='80' class='center content_border'><a name="<%=i+1%>"><%=i+1%> 
		                     <%if(accid.get("USE_YN").equals("Y")){%>
		                     <%}else{%>
		                     (해약) 
		                     <%}%>
		                   </a></td>
		                   <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='50' class='center content_border'> 
		                     <%if(String.valueOf(accid.get("SETTLE_ST")).equals("1")){%>
		                     	종결 
		                     <%}else{%>
		                     <font color="#FF6600">진행</font> 
		                     <%}%>
		                   </td>                   
		                   <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='40' class='center content_border'><a class=index1 href="javascript:parent.AccidentDisp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("ACCID_ID")%>', '<%=accid.get("ACCID_ST")%>', '<%=i%>', '10')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></td> 
		                   <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='70' class='center content_border'><%=accid.get("ACCID_ST_NM")%></td>
		                   <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='100' class='center content_border'><a href="javascript:parent.AccidentDisp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("ACCID_ID")%>', '<%=accid.get("ACCID_ST")%>', '<%=i%>', '0')" onMouseOver="window.status=''; return true" title='사고상세내역 보기'><%=accid.get("RENT_L_CD")%></a></td>
		                   <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='130' class='center content_border'> 
		                     <%if(accid.get("FIRM_NM").equals("(주)아마존카") && !accid.get("CUST_NM").equals("")){%>
		                     <span title='(<%=accid.get("RES_ST")%>)<%=accid.get("CUST_NM")%>'><a href="javascript:parent.view_client('<%=accid.get("RENT_MNG_ID")%>','<%=accid.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true" title='계약약식내역 팝업'>(<%=accid.get("RES_ST")%>)<%=Util.subData(String.valueOf(accid.get("CUST_NM")), 5)%></a></span>	
		                     <%}else{%>
		                     <span title='<%=accid.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true" title='계약약식내역 팝업'><%=Util.subData(String.valueOf(accid.get("FIRM_NM")), 9)%></a></span> 
		                     <%}%>
		                   </td>
		                   <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='90' class='center content_border'><a href="javascript:parent.view_car('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역 팝업'><%=accid.get("CAR_NO")%></a></td>
		                 </tr>
		            <%		}	%>
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
	    
			       <%	if(accid_size > 0){%> 	
			          <%		for (int i = 0 ; i < accid_size ; i++){
						Hashtable accid = (Hashtable)accids.elementAt(i);
						
							String content_code = "PIC_ACCID";
							String content_seq  = String.valueOf(accid.get("CAR_MNG_ID"))+""+String.valueOf(accid.get("ACCID_ID"));							
						%>
			                 <tr style="height: 25px;"> 
			                     <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='150' class='center content_border'><span title='<%=accid.get("CAR_NM")%> <%=accid.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(accid.get("CAR_NM"))+" "+String.valueOf(accid.get("CAR_NAME")), 12)%></span></td>
			                     <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='150' class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>
			                     <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='120' class="center content_border"><%=accid.get("OUR_NUM")%></td>
			                     <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='150' class="center content_border">&nbsp;<span title='<%=accid.get("ACCID_ADDR")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_ADDR")), 11)%></span></td>
			                     <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='150' class="center content_border">&nbsp;<span title='<%=accid.get("ACCID_CONT")%> <%=accid.get("ACCID_CONT2")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_CONT"))+" "+String.valueOf(accid.get("ACCID_CONT2")), 11)%></span></td>
			                     <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='100' class='center content_border'><%=c_db.getNameById(String.valueOf(accid.get("ACC_ID")), "USER")%></td>
			                     <td <%if(accid.get("USE_YN").equals("N")){%>class='is center content_border'<%}%> width='100' class='center content_border'><%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>                            
			                    
			                 </tr>
			            <%		}	%>
				 <%} else  {%>  
					       	<tr>
						       <td width="920" colspan="7" class='center content_border'>&nbsp;</td>
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
	parent.document.form1.size.value = '<%=accid_size%>';
//-->
</script>

</body>
</html>
