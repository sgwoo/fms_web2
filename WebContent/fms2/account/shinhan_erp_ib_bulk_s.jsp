<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.inside_bank.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	String bank_code = request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	
	String dt = request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
      
	if (t_wd.equals("")) t_wd = AddUtil.getDate(4);
	
		
	int ip_size = 0;  
	Vector ips = in_db.getIbBulkTranList(dt, ref_dt1, ref_dt2, asc, "" );

	ip_size = ips.size();	
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");		
	
	long t_cnt = 0;
	long t_amt = 0;

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
	
		
	//내역확인 
	function popup_ib_bulk(result_nm, bank_acc_nm, match_yn){
		var fm = document.form1;
		
		fm.result_nm.value = result_nm;
		fm.bank_acc_nm.value = bank_acc_nm;
		fm.match_yn.value = match_yn;
		
		w_width  = 1000;
		w_height = 500;
				
		var SUBWIN="ib_bulk_tran_lists.jsp";			
		window.open(SUBWIN, "VIEW_IB", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");	
		
		fm.action =SUBWIN;
		fm.method="post";
		fm.target="VIEW_IB";	
		fm.submit();

		
	}		
	
//-->
</script>
</head>

<body>
<form name='form1'  id="form1" action='' method='post' >
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type='hidden' name='ip_size' value='<%=ip_size%>'> 
<input type='hidden' name='dt' value='<%=dt%>'> 
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'> 
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'>
<input type='hidden' name='result_nm' >
<input type='hidden' name='bank_acc_nm' >
<input type='hidden' name='match_yn' >

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>				
				<td style="width: 100%;">
					<div style="width: 100%;">
						<table class="inner_top_table table_layout" style="height: 60px;">
							<tr>						
						        <td width='5%' class='title title_border' style='height:45'><!--  <input type="checkbox" name="all_pr" value="Y" onclick="javascript:AllSelect();">--></td> 
			                    <td class='title title_border' width=8%>연번</td>                                        
			                    <td class='title title_border' width=25%>예금주조회결과</td>   
			                    <td class='title title_border' width=25%>송금예금주</td>                          
			                    <td class='title title_border' width=12%>일치여부</td>
			                    <td class='title title_border' width=12%>건수</td>
			                    <td class='title title_border' width=16%>금액</td> 
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
					           
		          <%for (int i = 0 ; i < ip_size ; i++){
						Hashtable ht = (Hashtable)ips.elementAt(i);
						
						t_cnt  += AddUtil.parseLong(String.valueOf(ht.get("CNT")));
						t_amt  += AddUtil.parseLong(String.valueOf(ht.get("AMT")));
						
						String td_color = "";
						if(!String.valueOf(ht.get("SS")).equals("0")) td_color = "class='is center content_border'";
						%>
		                <tr style='height:30' > 
		                   <input type="hidden" name="idx" value="<%=i%>" >
		                    <td <%=td_color%> width='5%' class='center content_border'><input type="checkbox" name="ch_cd" value="<%=ht.get("RESULT_NM")%>^<%=ht.get("BANK_ACC_NM")%>^<%=ht.get("MATCH_YN")%>" ></td>
		                    <td <%=td_color%> width=8%  class="center content_border"><%=i+1%></td>                                               
		                    <td <%=td_color%> width=25% class="center content_border"><%=ht.get("RESULT_NM")%></td>   
		                    <td <%=td_color%> width=25% class="center content_border"><%=ht.get("BANK_ACC_NM")%></td>                        
		                    <td <%=td_color%> width=12% class="center content_border"><%=ht.get("MATCH_YN")%></td>
		                    <td <%=td_color%> width=12% class="center content_border"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>                 
		                    <td <% if(!String.valueOf(ht.get("SS")).equals("0")) { %> class='is right content_border' <%} %> width=16% class="right content_border">
		                    <a href="javascript:popup_ib_bulk('<%=ht.get("RESULT_NM")%>', '<%=ht.get("BANK_ACC_NM")%>', '<%=ht.get("MATCH_YN")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></a>
		                    </td>
		                 
		                </tr>
		          <%		}%>
		                  <tr style='height:30' > 
		                    <td width='30' class='title center content_border'></td>
		                    <td class="title center content_border" colspan=4>계</td>      
		                    <td class="title center content_border"><%=AddUtil.parseDecimalLong(t_cnt)%></td>                 
		                    <td class="title right content_border"><%=AddUtil.parseDecimalLong(t_amt)%></td>
		                 
		                </tr>
		            </table>
         	 	</div>  
        	</td>
   		 </tr>
   	 </table>
	</div>
</div>  

</form>
 	 	
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>

<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
		
	
 	}
//-->
</script> 	 	 	 	  	
</body>
</html>