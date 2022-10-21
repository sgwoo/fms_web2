<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*"%>
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
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt =  pm_db.getPayRList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
%>

<html style="overflow: hidden;">
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

<script type="text/javascript">
$('document').ready(function() {
	//div값 화면 셋팅값으로 초기화
	var frame_height = Number($("#height").val());
	//var frame_height = Number(document.body.offsetHeight);
	
	var form_width = Number($("#form1").width());		
	var title_width = Number($("#td_title").width());
	var title_height = Number($(".left_header_table").height());
	
	$(".left_contents_div").css("height", (frame_height - title_height) - 32);	
	$(".right_contents_div").css("height", (frame_height - title_height) - 32);
	/* $(".left_contents_div").css("height", frame_height - 100);	
	$(".right_contents_div").css("height", frame_height - 100); */
	
	$(".right_header_div").css("width", form_width - title_width);
	$(".right_contents_div").css("width", form_width - title_width);
		
	//브라우저 리사이즈시 width, height값 조정
	$(window).resize(function (){
		
		var frame_height = Number($("#height").val());
		//var frame_height = Number(document.body.offsetHeight);
		
		var form_width = Number($("#form1").width());
		var title_width = Number($("#td_title").width());		
		var title_height = Number($(".left_header_table").height());
		
		$(".left_contents_div").css("height", (frame_height - title_height) - 32);	
		$(".right_contents_div").css("height", (frame_height - title_height) - 32);
		/* $(".left_contents_div").css("height", frame_height - 100);	
		$(".right_contents_div").css("height", frame_height - 100); */
		
		$(".right_header_div").css("width", form_width - title_width);
		$(".right_contents_div").css("width", form_width - title_width);		
	})

});
</script>

<script language='javascript'>
<!--

	
		//레이아웃 스크롤 제어
	function fixDataOnWheel(){
        if(event.wheelDelta < 0){
            DataScroll.doScroll('scrollbarDown');
        }else{
            DataScroll.doScroll('scrollbarUp');
        }d
        dataOnScroll();
    }
	
	function dataOnScroll() {
        left_contents.scrollTop = right_contents.scrollTop;
        right_header.scrollLeft = right_contents.scrollLeft;
    }
 //-->   
</script>

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
//-->
</script>
</head>
<body>
<form name='form1' id="form1"   method='post' target='d_content'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='req_dt'    value=''>      
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_r_frame.jsp'>  
  <input type='hidden' name='height' id="height" value='<%=height%>'>
  
<table border="0" cellspacing="0" cellpadding="0" width='2020'>
  <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='' width='500' id='td_title'>		
		    <div id="left_header" class="left_header_div" style="width:510px;">		
		            <table class="left_header_table" border="0" cellspacing="1" cellpadding="0" width='100%'  height="60">
		               <tr>					
		                  <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
				          <td width='30' class='title'>연번</td>		    
						  <td width="60" class='title'>등록자</td>		  
				          <td width='80' class='title'>요청일자</td>		  
				          <td width='200' class='title'>지출처</td>
				          <td width='100' class='title'>금액</td>		
				        </tr>
			        </table>
		     </div>
		     <div id="left_contents" class="left_contents_div" style="width: 510px;" onmousewheel="fixDataOnWheel()" onScroll="dataOnScroll()">
		        	<table class="left_contents_table" border="0" cellspacing="1" cellpadding="0" width='100%'> 
		        	 <%if(vt_size > 0){%>				
					        <%	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
									total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
									%>
					        <tr> 
						          <td width='30' align='center'>
								  <%if(!String.valueOf(ht.get("ACT_BIT_NM")).equals("성공")){%>
								  <%	if(AddUtil.parseInt(String.valueOf(ht.get("ACT_DT"))) > 20100927 && String.valueOf(ht.get("I_TRAN_DT")).equals("")){//인사이드뱅크%>		  
								  <input type="checkbox" name="ch_cd" value="<%=ht.get("ACTSEQ")%>">
								  <%	}else if(AddUtil.parseInt(String.valueOf(ht.get("ACT_DT"))) <= 20100927 && String.valueOf(ht.get("TRAN_DT")).equals("")){//비즈파트너%>		  
								  <input type="checkbox" name="ch_cd" value="<%=ht.get("ACTSEQ")%>">		  
								  <%	}%>
								  <%}%>	
								  </td>		  
						          <td width='30' align='center'><%=i+1%></td>		  
								  <td width='60' align='center'><%=ht.get("REG_NM")%></td>		  		  		  
						          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACT_DT")))%></td>         		  
						          <td width='200'>&nbsp;
						          <%if(String.valueOf(ht.get("AT_ONCE")).equals("Y")){%>
						          <font color='red'>즉시</font>
						          <%} %>
						                  [<%=ht.get("PAY_REG_NM")%>]
								  <%if(String.valueOf(ht.get("ACT_BIT_NM")).equals("대기") || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%>
								  <a href="javascript:parent.view_pay_act('<%=ht.get("ACTSEQ")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 8)%></span></a>
								  <%}else{%>
								  <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 9)%></span>
								  <%}%>		  
								  </td>         		  		  		  
						  		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
	       				 </tr>      
	      		 		 <%	}%>
					<tr>						
					    <td class='title' colspan='5'>합계</td>
					    <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
					</tr>
				 <%} else  {%>  
		              	<tr>
				            <td align='center'>등록된 데이타가 없습니다</td>
				        </tr>	              
		              <%}	%>
		            </table>
		    </div>
	    </td>
   	    <td>	<!--  1520 -->		
		     <div id="right_header" class="right_header_div custom_scroll">
	            <table class="right_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="60">	   
	            
	              <colgroup>	 
	             		<col width='100' >
			            <col width='120' >
			            <col width='100' >
			            <col width='120' >
			            <col width='150' >
			            <col width='60' >
			          	<col width='80' >			          
			            <col width='80' >
			          	<col width='40' >
			            <col width='80' >
			            <col width='80' >
			            <col width='80' >
			            <col width='80' >
			            <col width='80' >
			            <col width='120' >
			            <col width='80' >			       	
		       		</colgroup>  
	                     
					<tr>
					  <td colspan="2" class='title'>출금정보</td>		
					  <td colspan="4" class='title'>입금정보</td>
					  <td colspan="2" class='title'>송금결과</td>
					  <td width="40" rowspan="2" class='title'>구분</td>		    		  		  
					  <td colspan="7" class='title'>은행연동</td>		    		  
					  <td width="30" rowspan="2" class='title'>-</td>		    		  		  		  
					</tr>
					<tr>
					  <td width='100' class='title'>금융사</td>
					  <td width='120' class='title'>계좌번호</td>
					  
					  <td width='100' class='title'>금융사</td>
					  <td width='120' class='title'>계좌번호</td>
					  <td width='150' class='title'>예금주</td>		  
					  <td width='60' class='title'>구분</td>		  
					  
					  <td width="80" class='title'>송금일자</td>
					  <td width="80" class='title'>송금수수료</td>		  
					  <td width="80" class='title'>이체수수료</td>		  
					  <td width="80" class='title'>이체후잔액</td>		  
					  <td width="80" class='title'>이체시간</td>		  
					  <td width="80" class='title'>오류코드</td>		  		  		  		  
					  <td width="80" class='title'>불능사유</td>		  		  		  		  		  
					  <td width="120" class='title'>성명조회결과</td>		  		  		  		  
					  <td width="80" class='title'>일치여부</td>		  		  		  		  		  
					</tr>
	  			</table>
	  	    </div>
		    <div id="right_contents" class="right_contents_div" onScroll="dataOnScroll()">
		       <table class="right_contents_table" border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <%if(vt_size > 0){%>
			 
			      <%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("COMMI")));
						total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("TRAN_FEE")));
				  %>
			       <tr>
					  <td width='100' align='center'><span title='<%=ht.get("A_BANK_NM")%>'><%=Util.subData(String.valueOf(ht.get("A_BANK_NM")), 6)%></span></td>
					  <td width='120' align='center'><%=ht.get("A_BANK_NO")%></td>
					  <td width='100' align='center'><span title='<%=ht.get("BANK_NM")%>'><%=Util.subData(String.valueOf(ht.get("BANK_NM")), 6)%></span></td>
					  <td width='120' align='center'><%=ht.get("BANK_NO")%></td>
					  <td width='150' align='center'><span title='<%=ht.get("BANK_ACC_NM")%>'><%=Util.subData(String.valueOf(ht.get("BANK_ACC_NM")), 10)%></span></td>		  
					  <td width='60' align='center'><a href="javascript:parent.reg_bank_acc_st('<%=ht.get("ACTSEQ")%>','<%=ht.get("BANK_NO")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=ht.get("CONF_ST_NM")%></a></td>
					  <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_ACT_DT")))%></td>					
					  <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("COMMI")))%></td>
					  <td width='40' align='center'><%=ht.get("ACT_BIT_NM")%></td>
					  <%if(AddUtil.parseInt(String.valueOf(ht.get("ACT_DT"))) > 20100927){//인사이드뱅크%>
					  <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("I_TRAN_FEE")))%></td>		  
					  <td width='80' align='right'><%if(!String.valueOf(ht.get("TRAN_STATUS")).equals("") && !String.valueOf(ht.get("TRAN_STATUS")).equals("02")){%><a href="javascript:parent.pay_ebank_del('<%=ht.get("ACTSEQ")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_cancel_yd.gif" align="absmiddle" border="0"></a><%}%></td>		  
					  <td width='80' align='center'><%=ht.get("TR_TIME")%></td>		  
					  <td width='80' align='center'><%=ht.get("TRAN_STATUS")%></td>		  
					  <td width='80' align='center'><%=ht.get("TRAN_STATUS_NM")%></td>		  		  		  		  		  		  		  		  
					  <%}else{//비즈파트너%>
					  <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TRAN_FEE")))%></td>		  
					  <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TRAN_REMAIN")))%></td>		  
					  <td width='80' align='center'><%=ht.get("TRAN_TM")%><%if(!String.valueOf(ht.get("ERR_CODE")).equals("") && !String.valueOf(ht.get("ERR_CODE")).equals("005")){%><a href="javascript:parent.pay_ebank_del('<%=ht.get("ACTSEQ")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_cancel_yd.gif" align="absmiddle" border="0"></a><%}%></td>		  
					  <td width='80' align='center'><%=ht.get("ERR_CODE")%></td>		  
					  <td width='80' align='center'><%=ht.get("ERR_REASON")%></td>		  		  		  		  		  		  		  
					  <%}%>
					  <td width='120' align='center'><%=ht.get("RESULT_NM")%></td>		  
					  <td width='80' align='center'><%=ht.get("MATCH_YN")%></td>		  		  		  		  		  		  		  
					  <td width='30' align='center'> </td>		  
				 </tr>	
	       		 <%	}%>
				 <tr>						
					    <td class='title'>&nbsp;</td>
					    <td class='title'>&nbsp;</td>
					    <td class='title'>&nbsp;</td>					
					    <td class='title'>&nbsp;</td>
					    <td class='title'>&nbsp;</td>
					    <td class='title'>&nbsp;</td>
					    <td class='title'>&nbsp;</td>
					    <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
					    <td class='title'>&nbsp;</td>
					    <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt3)%></td>
					    <td class='title'>&nbsp;</td>
					    <td class='title'>&nbsp;</td>
					    <td class='title'>&nbsp;</td>
					    <td class='title'>&nbsp;</td>										
					    <td class='title'>&nbsp;</td>															
					    <td class='title'>&nbsp;</td>										
					    <td class='title'>&nbsp;</td>															
				    </tr>
     	<%} else  {%>  
		           	<tr>
				            <td width="1520" colspan="17" align='center'>&nbsp;</td>
				    </tr>	              
		    <%}	%>
	            </table>
	            </div>
	    </td>
    </tr>
  </table>  

</form>

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

