<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	
	
	
	Vector exps = ex_db.getCarExpList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int exp_size = exps.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='exp_size' value='<%=exp_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1350>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width=40% id='td_title' style='position:relative;'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
			    <tr>
    			    <td width=8% class='title'>연번</td>
    			    <td width=17% class='title'>현재차량번호</td>
    			    <td width=17% class='title'>납부차량번호</td>			  
    			    <td width=8% class='title'>지역</td>
    			    <td width=30% class='title'>과세기간</td>
                    <td width=15% class='title'>사유발생일자</td>			  
			    </tr>
		    </table>
		</td>
		<td class='line' width=60%>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
        			<td width=12% class='title'>납부세액</td>
        			<td width=11% class='title'>납부일자</td>
                    <td width=10% class='title'>환급사유</td>
                    <td width=10% class='title'>미사용일수</td>			
                    <td width=12% class='title'>환급예정금액</td>
                    <td width=11% class='title'>환급신청일</td>			
                    <td width=11% class='title'>환급금액</td>
                    <td width=11% class='title'>환급일자</td>
                    <td width=12%' class='title'>실납부세액</td>			
                </tr>
            </table>
		</td>
	</tr>
<%	if(exp_size > 0){%>
	<tr>
		<td class='line' width=40% id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <%for(int i = 0 ; i < exp_size ; i++){
				Hashtable exp = (Hashtable)exps.elementAt(i);%>
                <tr> 
                    <td width=8% align='center'><%=i+1%></td>
                    <td width=17% align='center'><a href="javascript:parent.view_exp('<%=exp.get("CAR_MNG_ID")%>', '<%=exp.get("EXP_ST")%>', '<%=exp.get("EXP_EST_DT")%>', '<%=auth_rw%>')" onMouseOver="window.status=''; return true"><%=exp.get("CAR_NO")%></a></td>
                    <td width=17% align='center'><%=exp.get("EXP_CAR_NO")%></td>			
                    <td width=8% align='center'><a href="javascript:parent.view_car('<%=exp.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=exp.get("EXP_GOV")%></a></td>
                    <td width=30% align='center'><%=AddUtil.ChangeDate2(String.valueOf(exp.get("EXP_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(exp.get("EXP_END_DT")))%></td>
                    <td width=15% align='center'><%=AddUtil.ChangeDate2(String.valueOf(exp.get("RTN_CAU_DT")))%></td>
                </tr>
                <%}%>
                <tr>

                    <td class='title'></td>
                    <td class='title'></td>			
                    <td class='title'></td>
                    <td class='title'>합계</td>
                    <td class='title'></td>
                    <td class='title'></td>
                </tr>
            </table>
		</td>
		<td class='line' width=60%>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <%for(int i = 0 ; i < exp_size ; i++){
				Hashtable exp = (Hashtable)exps.elementAt(i);
				long exp_amt 		= Long.parseLong(String.valueOf(exp.get("EXP_AMT")));
				long rtn_est_amt 	= Long.parseLong(String.valueOf(exp.get("RTN_EST_AMT")));
				long rtn_amt 		= Long.parseLong(String.valueOf(exp.get("RTN_AMT")));
				long r_exp_amt 		= exp_amt-rtn_amt;
				total_amt2   		= total_amt2  + rtn_est_amt;
				total_amt3   		= total_amt3  + rtn_amt;
				total_amt4   		= total_amt4  + r_exp_amt;
				total_amt1   		= total_amt1  + Long.parseLong(String.valueOf(exp.get("EXP_AMT")));
				%>
                <tr> 
                    <td width=12% align='right'><%=Util.parseDecimal(String.valueOf(exp.get("EXP_AMT")))%>원&nbsp;</td>
                    <td width=11% align='center'><%=AddUtil.ChangeDate2(String.valueOf(exp.get("EXP_DT")))%></td>		  
                    <td width=10% align='center'><a href="javascript:parent.view_car('<%=exp.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=exp.get("RTN_CAU")%></a></td>
                    <td width=10% align='center'><%=exp.get("NO_USE_DAY")%>일</td>			
                    <td width=12% align='right'><%=Util.parseDecimal(String.valueOf(exp.get("RTN_EST_AMT")))%>원&nbsp;</td>
                    <td width=11% align='center'><%=AddUtil.ChangeDate2(String.valueOf(exp.get("RTN_REQ_DT")))%></td>			
                    <td width=11% align='right'><%=Util.parseDecimal(String.valueOf(exp.get("RTN_AMT")))%>원&nbsp;</td>
                    <td width=11% align='center'><%=AddUtil.ChangeDate2(String.valueOf(exp.get("RTN_DT")))%></td>
                    <td width=12% align='right'><%=Util.parseDecimal(r_exp_amt)%>원&nbsp;</td>			
                </tr>
          <%}%>
                <tr> 
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%>원&nbsp;</td>
                    <td class='title'></td>
                    <td class='title'></td>			
                    <td class='title'></td>			
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt2)%>원&nbsp;</td>
                    <td class='title'></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt3)%>원&nbsp;</td>
                    <td class='title'></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt4)%>원&nbsp;</td>
                </tr>
            </table>
		</td>
<%	}else{%>
	<tr>
		<td class='line' width=40% id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
		    </table>
		</td>
		<td class='line' width=60%>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
			        <td>&nbsp;</td>
		        </tr>
		  </table>
		</td>
	</tr>
<%	}%>
</table>
</form>
</body>
</html>
