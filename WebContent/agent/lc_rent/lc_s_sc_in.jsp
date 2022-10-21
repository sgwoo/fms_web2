<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
 	//chrome 관련 
 	String height = request.getParameter("height")==null?"":request.getParameter("height");
		
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean = umd.getUsersBean(ck_acar_id);
	
	
	Vector vt = ec_db.getContListAgent_20181022(s_kd, t_wd, andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, ck_acar_id, user_bean.getSa_code());
	int cont_size = vt.size();
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<style>
.left_contents_div::-webkit-scrollbar {
    width: 0.1px;
    background: transparent;
}
.left_contents_div { 
	overflow-y: overlay !important;
}	
.right_contents_div {
	/* overflow-x: auto !important; */
}

/* html {scrollbar-3dLight-Color: #efefef; scrollbar-arrow-color: #dfdfdf; scrollbar-base-color: #efefef; scrollbar-Face-Color: #dfdfdf; scrollbar-Track-Color: #efefef; scrollbar-DarkShadow-Color: #efefef; scrollbar-Highlight-Color: #efefef; scrollbar-Shadow-Color: #efefef} */

/* Chrome, Safari용 스크롤 바 */
/* ::-webkit-scrollbar {width: 8px; height: 8px; border: 3px solid #fff; }
::-webkit-scrollbar-button:start:decrement, ::-webkit-scrollbar-button:end:increment {display: block; height: 10px; background: url('./images/bg.png') #efefef}
::-webkit-scrollbar-track {background: #efefef; -webkit-border-radius: 10px; border-radius:10px; -webkit-box-shadow: inset 0 0 4px rgba(0,0,0,.2)}
::-webkit-scrollbar-thumb {height: 50px; width: 50px; background: rgba(0,0,0,.2); -webkit-border-radius: 8px; border-radius: 8px; -webkit-box-shadow: inset 0 0 4px rgba(0,0,0,.1)} */
</style>
</head>
<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  
						        <td width='40' class='title title_border'>연번</td>
				                <td width='40' class='title title_border'>구분</td>
				                <td width="40" class='title title_border'>문자</td>	
					       		<td width="40" class='title title_border'>스캔</td>						       	  				  	  
				                <td width='120' class='title title_border'>계약번호</td>
				                <td width='80' class='title title_border'>계약일</td>
				                <td width="200" class='title title_border'>고객</td>     		
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
						  	<colgroup>
				       		 	<col width="150">
				       			<col width="100">
				       			<col width="40">
				       					       			
				       			<col width="70"> <!-- 보험  rowspan -->
				       					       			
				       			<col width="80">
				       			<col width="70">
				       			<col width="80">
				       			<col width="70">
				       			<col width="70">
				       			<col width="70">
				       			<col width="50">
				       			<col width="80">
				       			<col width="80">
				       			
				       			<col width="70">		       			
				       			<col width="70">		       			
				       			<col width="70">		      						  
				       		</colgroup>		       																	
							
			        		<tr> 
							  <td colspan="3" class='title title_border'>자동차</td>
			        		  <td rowspan="2" width="70" class='title title_border'>보험사</td>
			        		  <td colspan="9" class='title title_border'>계약</td>
			        		  <td colspan="3" class='title title_border'>관리</td>						
							</tr>
							<tr> 
							   <td width="150" class='title title_border'>차종</td>
			        		   <td width="100" class='title title_border'>차량번호</td>
			        		   <td width="40" class='title title_border'>지역</td>
			        	       <td width='80' class='title title_border'>해지구분</td>
			        	       <td width='70' class='title title_border'>계약구분</td>
			        	       <td width='80' class='title title_border'>영업구분</td>
			        	       <td width='70' class='title title_border'>차량구분</td>
			        	       <td width='70' class='title title_border'>용도구분</td>
			        	       <td width='70' class='title title_border'>관리구분</td>
			        	       <td width='50' class='title title_border'>기간</td>
			        	       <td width='80' class='title title_border'>대여개시일</td>
			        	       <td width='80' class='title title_border'>대여만료일</td>
			        		   <td width='70' class='title title_border'>최초영업자</td>
			        		   <td width='70' class='title title_border'>영업대리인</td>
			        		   <td width='70' class='title title_border'>영업담당자</td>
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
      
					<%if(cont_size > 0){%>
					  <%	for(int i = 0 ; i < cont_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
									String td_color = "";
									
									if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=' is center content_border' ";
																											
									//직원 신차는 안보임
									//if(String.valueOf(ht.get("CAR_GU")).equals("신차") && !String.valueOf(ht.get("DEPT_ID")).equals("1000") && AddUtil.parseInt(String.valueOf(ht.get("ADD_MON50_DT"))) < AddUtil.parseInt(String.valueOf(ht.get("RENT_START_DT"))) ) continue;
									
									count++;
									
									%>
			                <tr style="height: 25px;"> 
			                  <td <%=td_color%> width='40' class='center content_border'><%=count%></td>                  
			                  <td <%=td_color%> width='40' class='center content_border'>
			                          <%if(String.valueOf(ht.get("USE_YN")).equals("")){%>
			                              <%if(String.valueOf(ht.get("SANCTION_ST")).equals("요청")){%><font color=red><%}else{%><font color=#000000><%}%>
			                              <%=ht.get("SANCTION_ST")%></font>
			                          <%}else if(String.valueOf(ht.get("USE_YN")).equals("Y")){%>진행<%}else if(String.valueOf(ht.get("USE_YN")).equals("N")){%>해지<%}%>                  
			                  </td>
			                  <td <%=td_color%> width='40' class='center content_border'><a href="javascript:parent.view_sms_send('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='문자발송'><img src=/acar/images/center/icon_tel.gif align=absmiddle border=0></a></td>
			        	        <td <%=td_color%> width='40' class='center content_border'><a href="javascript:parent.view_scan('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='스캔관리'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>		          	  
			                  <td <%=td_color%> width='120' class='center content_border'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>', '<%=ht.get("CAR_ST")%>', '<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%>','<%=ht.get("SANCTION_ST")%>','<%=ht.get("REG_STEP")%>')" onMouseOver="window.status=''; return true" title='계약상세내역'><%=ht.get("RENT_L_CD")%></a></td>
			                  <td <%=td_color%> width='80' class='center content_border'>
			                      <%if(String.valueOf(ht.get("CNG_ST")).equals("계약승계") && String.valueOf(ht.get("EXT_ST2")).equals("")){%>
			                            <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%>
			                        <%}else{%>
			                            <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
			                        <%}%>         
			                  </td>
			                  <td <%=td_color%> width='200' class='center content_border'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true" title='계약약식내역'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 15)%></span></a></td>
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
	       	  
			    <%if(cont_size > 0){%>  
			           <%	for(int i = 0 ; i < cont_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								String td_color = "";
								if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=is ";
					
								//직원 신차는 안보임
								//if(String.valueOf(ht.get("CAR_GU")).equals("신차") && !String.valueOf(ht.get("DEPT_ID")).equals("1000") && AddUtil.parseInt(String.valueOf(ht.get("ADD_MON50_DT"))) < AddUtil.parseInt(String.valueOf(ht.get("RENT_START_DT")))) continue;
								
								String ins_com_nm = c_db.getNameById(String.valueOf(ht.get("INS_COM_ID")),"INS_COM");						
						%>
			        		<tr style="height: 25px;"> 
			        		  <td <%=td_color%> width='150' class='center content_border'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
			        		  <td <%=td_color%> width='100' class='center content_border'><a href="javascript:parent.view_car('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'><%=ht.get("CAR_NO")%></a></td>					
			        		  <td <%=td_color%> width='40' class='center content_border'><%=ht.get("CAR_EXT")%></td>        		  
			        		  <td <%=td_color%> width='70' class='center content_border'><span title='<%=ins_com_nm%>'><%=AddUtil.subData(ins_com_nm, 4)%></span></td>		  		  
			        		  <td <%=td_color%> width='80' class='center content_border'><%=ht.get("CLS_ST")%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'>
							        <%if(String.valueOf(ht.get("CNG_ST")).equals("")){%>
								<%	if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%>
								<%	}else{%><%=ht.get("EXT_ST")%>
								<%	}%>
								<%}else{%>
								<%	if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%>
								<%	}else{%><%=ht.get("EXT_ST2")%>
								<%      }%>
								<%}%>
						 	 </td>		  
			        		  <td <%=td_color%> width='80' class='center content_border'><%=ht.get("BUS_ST")%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=ht.get("CAR_GU")%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=ht.get("CAR_ST")%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=ht.get("RENT_WAY")%></td>	
			        		  <td <%=td_color%> width='50' class='center content_border'><%=ht.get("CON_MON")%><%if(String.valueOf(ht.get("EXT_ST")).equals("연장")){%>(<%=ht.get("EXT_MON")%>)<%}%></td>
			        		  <td <%=td_color%> width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
			        		  <td <%=td_color%> width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=ht.get("BUS_NM")%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><span title='<%=ht.get("BUS_AGNT_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("BUS_AGNT_NM")), 3)%></span></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=ht.get("BUS_NM2")%></td>
			        		</tr>
					 <%		}	%> 		
			      <%} else  {%>  
					       	<tr>
						       <td width="1220" colspan="16" class='center content_border'>&nbsp;</td>
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
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>


