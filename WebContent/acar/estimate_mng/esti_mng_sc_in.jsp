<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	if (!gubun4.equals("3")) {
		s_dt = "";
		e_dt = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//????????
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstimateBean [] e_r = e_db.getEstimateFmsList(gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, s_dt, e_dt, s_kd, t_wd);
	int size = e_r.length;
	
	EstimateBean e_bean1 = new EstimateBean();
	
	String admin_yn="";
	if(nm_db.getWorkAuthUser("??????",user_id)){
		admin_yn="Y";
	}
%>
<html style="overflow: hidden;">
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">


<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
$('document').ready(function() {
	//div?? ???? ?????????? ??????
	var frame_height = Number($("#height").val());
	//var frame_height = Number(document.body.offsetHeight);
	
	var form_width = Number($("#form1").width());	
	var title_width = Number($("#td_title").width());
	var title_height = Number($(".left_header_table").height());
	
	$(".left_contents_div").css("height", (frame_height - title_height) - 50);	
	$(".right_contents_div").css("height", (frame_height - title_height) - 50);
	/* $(".left_contents_div").css("height", frame_height - 100);	
	$(".right_contents_div").css("height", frame_height - 100); */
	
	$(".right_header_div").css("width", form_width - title_width);
	$(".right_contents_div").css("width", form_width - title_width);
		
	//???????? ?????????? width, height?? ????
	$(window).resize(function (){
		
		var frame_height = Number($("#height").val());
		//var frame_height = Number(document.body.offsetHeight);
		
		var form_width = Number($("#form1").width());
		var title_width = Number($("#td_title").width());		
		var title_height = Number($(".left_header_table").height());
		
		$(".left_contents_div").css("height", frame_height - title_height);	
		$(".right_contents_div").css("height", frame_height - title_height);
		/* $(".left_contents_div").css("height", frame_height - 100);	
		$(".right_contents_div").css("height", frame_height - 100); */
		
		$(".right_header_div").css("width", form_width - title_width);
		$(".right_contents_div").css("width", form_width - title_width);		
	})

});
</script>
<script language="JavaScript">
<!--
	//????????
	function EstiDisp(est_id, set_code) {	
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.set_code.value = set_code;
		if(set_code == '') {
			fm.action = 'esti_mng_u.jsp';
		} else {
			fm.action = 'esti_mng_atype_u.jsp';
		}

		fm.target = 'd_content';
		fm.submit();
	}
	
	function EstiMemo(est_id, user_id) {
		var SUBWIN = "./esti_memo_i.jsp?est_id="+est_id+"&user_id="+user_id+"&from_page=esti_mng_sc_in.jsp";
		window.open(SUBWIN, "EstiMemoDisp", "left=50, top=50, width=620, height=650, scrollbars=yes");
	}
//-->
</script>
<script language='javascript'>
<!--
	
	
	//????????
	function AllSelect() {
		var fm = document.form1;
		//var len = fm.elements.length;
		var len = document.getElementsByName("ch_l_cd").length;
		var cnt = 0;
		var idnum = "";
		for (var i = 0; i < len; i++) {
			//var ck = fm.elements[i];
			var ck = document.getElementsByName("ch_l_cd")[i];
			if (ck.checked == false) {
				ck.click();
			} else {
				ck.click();
			}
		}
	}
	
	//???????? ?????? ????
	function fixDataOnWheel() {
		if (event.wheelDelta < 0) {
            DataScroll.doScroll('scrollbarDown');
        } else {
            DataScroll.doScroll('scrollbarUp');
        }d 
        dataOnScroll();
    }
	
	function dataOnScroll() {
        left_contents.scrollTop = right_contents.scrollTop;
        right_header.scrollLeft = right_contents.scrollLeft;
    }
	
	/* 
	function dataOnScrollLeft() {
        right_contents.scrollTop = left_contents.scrollTop;
    }
	*/
	
//-->
</script>
</head>
<body> 
<form id="form1" action="esti_mng_u.jsp" name="form1" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">  
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="gubun1" value="<%=gubun1%>">
	<input type="hidden" name="gubun2" value="<%=gubun2%>">
	<input type="hidden" name="gubun3" value="<%=gubun3%>">
	<input type="hidden" name="gubun4" value="<%=gubun4%>">  
	<input type="hidden" name="gubun5" value="<%=gubun5%>">
	<input type="hidden" name="gubun6" value="<%=gubun6%>">  
	<input type="hidden" name="s_dt" value="<%=s_dt%>">
	<input type="hidden" name="e_dt" value="<%=e_dt%>">
	<input type="hidden" name="s_kd" value="<%=s_kd%>">          
	<input type="hidden" name="t_wd" value="<%=t_wd%>"> 
	<input type="hidden" name="esti_m" value="<%=esti_m%>"> 
	<input type="hidden" name="esti_m_dt" value="<%=esti_m_dt%>"> 
	<input type="hidden" name="esti_m_s_dt" value="<%=esti_m_s_dt%>"> 
	<input type="hidden" name="esti_m_e_dt" value="<%=esti_m_e_dt%>">         
	<input type="hidden" name="est_id" value="">          
	<input type="hidden" name="set_code" value="">            
	<input type="hidden" name="cmd" value="">
	<input type="hidden" name="from_page" value="/acar/estimate_mng/esti_mng_sc_in.jsp">
	<input type='hidden' name='height' id="height" value='<%=height%>'>
	
<table border=0 cellspacing=0 cellpadding=0 width=1950>
    <!--
	<tr>
        <td class=line2 colspan=2></td>
    </tr>
    -->
    <tr id="tr_title" style="position:relative; z-index: 1;"> 
        <td width=550 id="td_title"> 
        	<div id="left_header" class="left_header_div" style="width:560px;">
	            <table class="left_header_table" border="0" cellspacing="1" cellpadding="0" width=100%>
	                <tr> 
	                    <td width="40" class="title">????</td>
	                    <td width="40" class="title">????</td>
			    		<td width="40" class='title'>
			    			<input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();">
			    		</td>					
			    		<td width="110" class="title">????????</td>
	                    <td width="60" class="title">????????</td>
	                    <td width="150" class="title">????????</td>
	                    <td width="100" class="title">??????</td>
	                </tr>
	            </table>
            </div>
            <div id="left_contents" class="left_contents_div" style="width: 560px;" onmousewheel="fixDataOnWheel()"> <!-- onScroll="dataOnScrollLeft()" -->  
	            <table class="left_contents_table" border="0" cellspacing="1" cellpadding="0" width=100%>
	            	<%for (int i = 0; i < size; i++) {
							bean = e_r[i];						
							e_bean1 = e_db.getEstimateCase(bean.getEst_id());
					%>
	                <tr> 
	                    <td width="40" align="center">
	                    	<a href="javascript:EstiMemo('<%=bean.getEst_id()%>', '<%=user_id%>')">
	                    		<%=i+1%>
	                    	</a>
	                    </td>
	                    <td width="40" align="center">
	                    <% 
	                   	EstiMBean em_r [] = e_db.getEstiMAll(bean.getEst_id(), user_id);
	                   	if (em_r.length > 0) {
	               		%>
	                   		<a href="javascript:EstiMemo('<%=bean.getEst_id()%>', '<%=user_id%>')">
	                   			<img src=../images/esti_detail.gif align=absmiddle>
	                   		</a>
	              		<% 
	                   	}
	                   	%>
	                    </td>
			    		<td width="40" align="center">
			    			<input type="checkbox" name="ch_l_cd" value="<%=bean.getEst_id()%>">
			    			<input type="hidden" name="gree_dist" value="<%=AddUtil.parseDecimal(e_bean1.getAgree_dist())%>">
			    		</td>			    		
	                    <td width="110" align="center"><%=c_db.getNameByIdCode("0009", "", bean.getA_a())%></td>
	                    <td width="60" align="center"><%=bean.getA_b()%>????</td>
	                    <td width="150" align="center">
	                    	<a href="javascript:EstiDisp('<%=bean.getEst_id()%>', '<%=bean.getSet_code()%>')">
	                    		<%= AddUtil.ChangeDate3(bean.getReg_dt()) %>
	                    	</a>
	                    </td>
	                    <td width="100" align="center">
	                    	<span title='<%=bean.getEst_nm()%> || <%=bean.getMgr_nm()%>'>
	                    		<%=AddUtil.substringbdot(bean.getEst_nm(), 12)%>
	                    	</span>
	                    </td>
	                </tr>
                  	<%}%>
                  	<% if(size == 0) { %>
	                <tr> 
	                    <td width="550" align="center" colspan="7">?????? ???????? ????????.</td>
	                </tr>
	          		<%}%>
	            </table>
            </div>
        </td>
        <td>
        	<div id="right_header" class="right_header_div custom_scroll">
	            <table class="right_header_table" border="0" cellspacing="1" cellpadding="0" width=100%>
	                <tr> 
	                    <td width="110" class="title">??????</td>
	                    <td width="200" class="title">????</td>
	                    <td width="95" class="title">????????</td>
	                    <td width="80" class="title">????????</td>			
	                    <td width="50" class="title">??????</td>	
	                    <td width="50" class="title">D/C??</td>					
	                    <td width="90" class="title">??????</td>
	                    <td width="60" class="title">????????</td>			
	                    <td width="85" class="title">??????</td>									
	                    <td width="80" class="title">??????????</td>												
	                    <td width="60" class="title">??????</td>
	                    <td width="100" class="title">??????DC</td>
	                    <td width="250" class="title">????????</td>
	                    <td width="100" class="title">??????????</td>
	                </tr>
	            </table>
            </div>
            <div id="right_contents" class="right_contents_div" onScroll="dataOnScroll()">
	            <table class="right_contents_table" border="0" cellspacing="1" cellpadding="0" width=100%>
	                <%for (int i = 0; i < size; i++) {
	    					bean = e_r[i];
	    					
	    					if (bean.getCtr_s_amt()>0) {
	    						bean.setFee_s_amt(bean.getCtr_s_amt());
	    						bean.setFee_v_amt(bean.getCtr_v_amt());
	    					}
   					%>
	                <tr> 
	                    <td width="110" align="center">
	                    	<span title='<%=bean.getEst_tel()%>'><%=AddUtil.substringbdot(bean.getEst_tel(), 13)%></span>
	                    </td>
	                    <td width="200" align="center">
	                    	<span title='<%=bean.getCar_nm()+" "+ bean.getCar_name()%>'>
	                    		<%=AddUtil.substringbdot(bean.getCar_nm()+" "+ bean.getCar_name(), 28)%>
	                    	</span>
	                    </td>
	                    <td width="95" align="right"><%=Util.parseDecimal(bean.getO_1())%>??</td>
	                    <td width="80" align="right">
                        <%if (bean.getUse_yn().equals("N")) {%>
                        	????
                        <%} else {%>
                        	<%if (bean.getFee_s_amt() == 0 && bean.getEst_check().equals("????????")) {%>
                            	????????
                        	<%} else {%>
                            	<%if (bean.getFee_s_amt() == -1) {%>
                            		??????
                            	<%} else {%>
                            		<%=Util.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt())%>??
                            	<%}%>
                        	<%}%>
                        <%}%>
	                    </td>
	                    <td width="50" align="center"><%=bean.getO_11()%>%</td>
	                    <td width="50" align="center"><%=bean.getFee_dc_per()%>%</td>
	                    <td width="90" align="right"><%=Util.parseDecimal(bean.getGtr_amt())%>??</td>
	                    <td width="60" align="center"><%=bean.getRg_8()%>%</td>
	                    <td width="85" align="right"><%=Util.parseDecimal(bean.getPp_s_amt()+bean.getPp_v_amt())%>??</td>
	                    <td width="80" align="right"><%=Util.parseDecimal(bean.getIfee_s_amt()+bean.getIfee_v_amt())%>??</td>	                    
	                    <td width="60" align="center">
                    		<span title='<%=bean.getReg_nm()%>'><%=AddUtil.substringbdot(bean.getReg_nm(),6)%></span>
	                    </td>
	                    <td width="100" align="right"><%=Util.parseDecimal(bean.getDc_amt())%>??</td>
	                    <td width="250" align="center">
	                        <%if (admin_yn.equals("Y")) {%>
	                        	[<%=bean.getPrint_type()%>/<%=Util.parseDecimal(bean.getCtr_s_amt()+bean.getCtr_v_amt())%>??]
	                        <%}%>
	                        <%=bean.getEst_email()%>
	                    </td>
	                    <td width="100" align="center"><%=bean.getDamdang_nm()%></td>
	                </tr>
	                <%}%>
	                <%if (size == 0) {%>
	                <tr> 
	                    <td width="1410" align="center" colspan="14" height=25 >?????? ???????? ????????.</td>
	                </tr>
	              	<%}%>
	            </table>
            </div>
        </td>
    </tr>
</table>
</form>
</body>
</html>
