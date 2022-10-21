<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String s_cpt = request.getParameter("s_cpt")==null?"":request.getParameter("s_cpt");
	String cmd = "";
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector fines = FineDocDb.getFineDocLists("총무", br_id, gubun, gubun2, gubun3,  gubun4, "L", st_dt, end_dt, s_kd, t_wd, sort, asc, s_cpt);
	int fine_size = fines.size();
	
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
//전체선택
function AllSelect(){
	var fm = document.form1;
	var len = fm.elements.length;
	var cnt = 0;
	var idnum ="";
	for(var i=0; i<len; i++){
		var ck = fm.elements[i];
		if(ck.name == "ch_cd"){		
			if(ck.checked == false){
				ck.click();
			}else{
				ck.click();
			}
		}
	}
	return;
}			

//-->
</script>
</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=fine_size%>'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='s_cpt' value='<%=s_cpt%>'>
<input type='hidden' name='asc' value='<%=asc%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>				
				<td style="width: 100%;">
					<div style="width: 100%;">
						<table class="inner_top_table table_layout" style="height: 60px;">	
							<tr>
							    <td class='title title_border' width=5%>연번</td>
							    <td width='4%' class='title title_border'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();">[자금]</td>
								<td width=6% class='title title_border'>저당권설정서류</td>
								<td width=4% class='title title_border'>담보구분</td>
			                    <td width=8% class='title title_border'>문서번호</td>
			                    <td width=8% class='title title_border'>시행일자</td>
			                    <td width=10% class='title title_border'>수신처</td>
								<td width=4% class='title title_border'>스케쥴</td>
			                    <td width=8% class='title title_border'> 실행일자</td>
			                    <td class='title title_border' width=5%>건수</td>
				                <td class='title title_border' width=7%>인쇄일자</td>
								<td class='title title_border' width=7%>입금일자</td>
				                <td class='title title_border' width=10%>공문</td>
				                <td class='title title_border' width=7%>세부내역서</td>				
				                <td class='title title_border' width=7%>CMS기관</td>			       		  
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
	    	    <td style="width: 100%;">
		   			 <div style="width: 100%;">
						<table class="inner_top_table table_layout">   	   
	    
			       <%if(fine_size > 0){%>
			              <%for(int i = 0 ; i < fine_size ; i++){
			    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
			              <tr> 
			                <td  class='center content_border' width=5%><%=i+1%></td>
			                <td  width='4%' class='center content_border'><input type="checkbox" name="ch_cd" value="<%=ht.get("DOC_ID")%>"  <% if ( String.valueOf(ht.get("FUND_YN")).equals("Y")   )  {%> disabled <% } %> >		                
			                <% if ( String.valueOf(ht.get("FUND_YN")).equals("Y")   )  {%> [리스] <% } %>
			                </td>
							<td  class='center content_border' width=6%><%if(ht.get("REGYN").equals("")){%><%}else if(ht.get("REGYN").equals("N")){%>미비<%}else{%>완료<%}%></td>
							<td  class='center content_border' width=4%><%if(ht.get("CLTR_CHK").equals("")){%><%}else if(ht.get("CLTR_CHK").equals("1")){%>개별<%}else{%>공동<%}%></td>
			                <td  width=8% class='center content_border'><a href="javascript:parent.view_fine_doc('<%=ht.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a></td>
			                <td  width=8% class='center content_border'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
			                <td  width=10% class='center content_border'><%=AddUtil.subData(String.valueOf(ht.get("GOV_NM")),8)%></td>
							<td  width=4% class='center content_border'><%=ht.get("SCD_YN")%></td>
			                <td  width=8% class='center content_border'><%=AddUtil.getDate3(String.valueOf(ht.get("END_DT")))%></td>
			                <td class="center content_border" width=5%><%=ht.get("CNT")%>건</td>
			                <td class="center content_border" width=7%><span title="<%=c_db.getNameById(String.valueOf(ht.get("PRINT_ID")), "USER")%>"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%></span></td>
							<td class="center content_border" width=7%><%if(!ht.get("IP_DT").equals("")){%><a href="javascript:parent.FineIP_DT('<%=ht.get("DOC_ID")%>', '<%=ht.get("GOV_ID")%>', '<%=ht.get("IP_DT")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("IP_DT")))%></a><%}else{%><a href="javascript:parent.FineIP_DT('<%=ht.get("DOC_ID")%>', '<%=ht.get("GOV_ID")%>', '<%=ht.get("IP_DT")%>');"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a><%}%></td>
			                <td  width=10% class='center content_border'><a href="javascript:parent.FineDocPrint('<%=ht.get("DOC_ID")%>', '<%=ht.get("GOV_ID")%>');"><img src=../images/center/button_in_print.gif align=absmiddle border=0></a>
							<%//if(user_id.equals("000096")||user_id.equals("000048")){%>
							&nbsp;<a href="javascript:parent.FineDocPrint2('<%=ht.get("DOC_ID")%>', '<%=ht.get("GOV_ID")%>', '<%=ht.get("CNT")%>');"><%if(ht.get("REQ_DT").equals("")){%><img src=../images/center/button_in_nchg.gif align=absmiddle border=0><%}else{%><img src=../images/center/button_in_chg.gif align=absmiddle border=0><%}%></a>
							<%//}%>
							</td>
			                <td  width=7% class='center content_border'><a href="javascript:parent.ObjectionPrint('<%=ht.get("DOC_ID")%>', '<%=ht.get("GOV_ID")%>');"><img src=../images/center/button_in_print.gif align=absmiddle border=0></a></td>			
			               <td  width=7% class='center content_border'><%=ht.get("CMS_CODE")%></td>			
			            
			              </tr>
			              <%}%>		  
			     <%} else  {%>  
					       	<tr>
						       <td  colspan="15" class='center content_border'>&nbsp;등록된 데이타가 없습니다</td>
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
