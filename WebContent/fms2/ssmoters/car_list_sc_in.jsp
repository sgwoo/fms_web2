<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.master_car.*" %>	
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	

	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
				
	Vector vt = mc_db.getSsmotersComAcarExcelList(gubun3, gubun2, s_kd, st_dt, end_dt, gubun1, t_wd, gubun4);
	int vt_size = vt.size();
	
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

<script language='javascript'>
<!--
		
	
	//출력하기
	function DocPrint(m1_no, l_cd){
		
		var SUMWIN = "";
			
		SUMWIN="doc_car_print.jsp?m1_no="+m1_no+"&l_cd="+l_cd;	
		
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	
//-->
</script>
</head>

<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
  <input type='hidden' name='height' id="height" value='<%=height%>'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  
<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width:650px;">
					<div style="width: 650px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  
					            <td class="title title_border" width='9%'>연번</td>
								<td class="title title_border" width='9%'>구분<br>차령<br>연장</td>	  
								<td class="title title_border" width='20%'>업체</td>	  
								<td class="title title_border" width='12%'>등록일자</td>	  	  
								<td class="title title_border" width='16%'>차량번호</td>
								<td class="title title_border" width='34%'>차종</td>
							</tr>
						</table>
					</div>
				</td>
				<td style="width: 2050px;">
					<div style="width: 2050px;">
						<table class="inner_top_table table_layout" style="height: 60px;">	
							<tr>					       	                	
			        	   	  <td class="title title_border" width='4%'>제조사</td>
							  <td class="title title_border" width='2%'>연식</td>
							  <td class="title title_border" width='3%'>연료</td>
							  <td class="title title_border" width='6%'>고객</td>
							  <td class="title title_border" width='4%'>사무실</td>
							  <td class="title title_border" width='12%'>주소</td>
							  <td class="title title_border" width='4%'>차량관리자</td>
							  <td class="title title_border" width='4%'>실운전자</td>		
							  <td class="title title_border" width='6%'>대여기간</td>			
							  <td class="title title_border" width='3%'>최초<br>등록일</td>		
							  <td class="title title_border" width='3%'>차령<br>만료일</td>		
							  <td class="title title_border" width='2%'>등록<br>지역</td>		
							  <td class="title title_border" width='3%'>대여방식</td>			
							  <td class="title title_border" width='2%'>관리<br>담당자</td>			
							  <td class="title title_border" width='4%'>연락처</td>	
							  <td class="title title_border" width='3%' >검사일</td>	
							  <td class="title title_border" width='2%'>종류</td>	
						  	  <td class="title title_border" width='3%'>검사금액</td>				        		  
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
				<td style="width: 650px;">
					<div style="width: 650px;">
						<table class="inner_top_table left_fix">  
					 	<%if(vt_size > 0){%>  
					        <%	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);	%>
					        <tr> 
						         <td class="center content_border" width='9%'>
						              
						         <%=i+1%></td>	
								  <td class="center content_border" width='9%'><%if( String.valueOf(ht.get("GUBUN")).equals("1") ){%>의뢰<%}else if (String.valueOf(ht.get("GUBUN")).equals("2") ){%>완료<%}else if (String.valueOf(ht.get("GUBUN")).equals("4") ){%>기타<%}else {%>취소<%}%> 
								  &nbsp;<font color=red><%=ht.get("AG")%></font>
								  </td>	  
								  <td class="center content_border" width='20%'>		
								  	<span title='<%=ht.get("업체")%>'><%=Util.subData(String.valueOf(ht.get("업체")),7)%></span></td>		  	
								  <td class="center content_border" width='12%'><%=ht.get("등록일자")%></td>	  	  
								  <td class="center content_border" width='16%'>
								   <a href="javascript:parent.view_jungsan('<%=ht.get("M1_NO")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("GUBUN")%>')" onMouseOver="window.status=''; return true">
						                <%=ht.get("차량번호")%>
						            </a></td>		  
								  <td class="center content_border" width='34%'>
								  <span title='<%=ht.get("차종")%>'><%=Util.subData(String.valueOf(ht.get("차종")),10)%></span></td>							 
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
			    
				<td style="width: 2050px;">		
		     	 <div style="width: 2050px;">
					<table class="inner_top_table table_layout">   	   		
		 	<%if(vt_size > 0){%>  		
	        <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
						<tr>
						  <td class="center content_border"	width='4%'><%=Util.subData(String.valueOf(ht.get("제조사")),4)%></td>
						  <td class="center content_border"	width='2%'><%=ht.get("연식")%></td>		   
						  <td class="center content_border"	width='3%'><%=Util.subData(String.valueOf(ht.get("연료")),4)%></td>
						  <td class="center content_border"	width='6%'>
						  <span title='<%=ht.get("고객")%>'>
						  <%if( String.valueOf(ht.get("CAR_ST")).equals("4") ) {%> (월)<%} else { %>&nbsp;<%} %><%=Util.subData(String.valueOf(ht.get("고객")),7)%></span></td>
						  <td class="center content_border"	width='4%'><%=ht.get("사무실")%></td>
						  <td class="center content_border"	width='12%'>
						   <span title='<%=ht.get("주소")%>'><%=Util.subData(String.valueOf(ht.get("주소")),24)%></span></td>	
						  <td class="center content_border"	width='4%'><%=ht.get("차량관리자")%></td>				  
						  <td class="center content_border"	width='4%'><%=ht.get("실운전자")%></td>	
						  <td class="center content_border"	width='6%'><%=ht.get("대여기간")%></td>
						  <td class="center content_border"	width='3%'><%=ht.get("최초등록일")%></td>
						  <td class="center content_border"	width='3%'><%=ht.get("차령만료일")%></td>
						  <td class="center content_border"	width='2%'><%=ht.get("등록지역")%></td>
						  <td class="center content_border"	width='3%'><%=ht.get("대여방식")%></td>	  
						  <td class="center content_border"	width='2%'><%=ht.get("관리담당자")%></td>
						  <td class="center content_border"	width='4%'><%=ht.get("연락처")%></td>	  
						  <td class="center content_border"	width='3%'><%=ht.get("검사일")%></td>	  
						  <td class="center content_border"	width='2%'><%=ht.get("종류")%></td>	  
						  <td class="right content_border"  	width='3%'><%=AddUtil.parseDecimal(ht.get("검사금액"))%></td>	
						</tr>
					
				<%	}	%>
			     <%} else  {%>  
				       	<tr>
					       <td  width="2050" colspan="18" class='center content_border'>&nbsp;</td>
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
