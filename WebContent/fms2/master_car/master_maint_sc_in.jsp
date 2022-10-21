<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.master_car.*, acar.user_mng.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_cus_reg_maint(car_mng_id, client_id, car_no, mdata){
		var fm = document.form1;
		var url = "/acar/cus_reg/cus_reg_maint.jsp?from_page=master_maint_sc_in.jsp&car_mng_id="+car_mng_id+"&client_id="+client_id+"&s_gubun1=3&s_kd=2&t_wd=&mdata="+mdata;
		window.open(url, "cus_reg", "left=50, top=50, width=1000, height=700, scrollbars=yes, status=yes");
	}
		//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
-->	
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	
	int total_su = 0;
	long total_amt = 0;
	String tot_dist = "";
	int chk_cnt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	

	Vector exps = mc_db.Car_MaintList_new(gubun1, gubun2, gubun3, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, s_st);
	int exp_size = exps.size();
%>

<form name='form1' method='post' >
<table border="0" cellspacing="0" cellpadding="0" width='100%'>    
    <tr>
	    <td class=line2 colspan=2></td>
	</tr>
	<tr id='tr_title' style='position:relative;z-index:1' >
		<td class='line' width='32%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' height=60>
				<tr>
					<td width='17%' class='title'>연번</td>
					<td width='27%' class='title'>검사일&nbsp;&nbsp;차령</td>	
					<td width='30%' class='title'>차량번호</td>		
					<td width='26%' class='title'>최초등록일</td>
				</tr>	
			</table>
		</td>
		<td class='line' width='68%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'  height=60>
                <tr> 
                    <td width='10%' class='title'>의뢰일</td>
                    <td width='13%' class='title'>차량명</td>
                    <td width='10%' class='title'>구분</td>                 
                    <td width='11%' class='title'>대행</td>   
                    <td width='13%' class='title'>출동점</td>               
                    <td width='7%' class='title'>금액</td>
                    <td width='7%' class='title'>주행거리</td>
                    <td width='8%' class='title'>등록</td>
                    <td width='15%' class='title'>특이사항</td>
                    <td width='6%' class='title'>담당자</td>
                </tr>
            </table>
		</td>
	</tr>
<%	if(exp_size > 0){ %>
	<tr >
		<td class='line' width='32%' id='td_con' style='position:relative;' height=80>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < exp_size ; i++){
				Hashtable exp = (Hashtable)exps.elementAt(i);
				%>
                <tr> 
                    <td width='17%' align='center'> 
                     <% if ( String.valueOf(exp.get("CAR_MNG_ID")).equals("")   &&  ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("과태료담당자",user_id)  ||user_id.equals("000131")  ||user_id.equals("000130")   )   ) { %>
                                          <a href="javascript:MM_openBrWindow('upd_l_cd.jsp?m1_no=<%=exp.get("JS_SEQ")%>','popwin','scrollbars=no,status=no,resizable=no,left=100,top=120,width=500,height=200')"><%=i+1%></a>                       
                            
                       <% } else { %><%=i+1%>                                
                        <%} %>         
                  </td>
                    
                    
                    <td width='27%' align='center'><%=AddUtil.ChangeDate2(AddUtil.toString(exp.get("JS_DT")))%>&nbsp; <font color=red><%=exp.get("AG")%></font></td>   
                    <td width='30%' align='center'><%=exp.get("CAR_NO")%>&nbsp;(<%=exp.get("CAR_MNG_ID")%>)</td>               
                    <td width='27%' align='center'><%=AddUtil.ChangeDate2(AddUtil.toString(exp.get("INIT_REG_DT")))%></td>
                </tr>
            <%}%>
                <tr> 
                    <td class="title" colspan=4>합계</td>
                </tr>
            </table>
		</td>
		<td class='line' width='68%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < exp_size ; i++){
				Hashtable exp = (Hashtable)exps.elementAt(i);
				%>
                <tr>  
                    <td width='10%' align='center'><%=AddUtil.toString(exp.get("M1_DT"))%></span></td>                 
                    <td width='13%' align='center'><span title='<%=exp.get("CAR_NM")%>'><%=Util.subData(String.valueOf(exp.get("CAR_NM")), 6)%></span></td>
                    <td width='10%' align='center'><%=exp.get("SSSSNY")%><%=exp.get("JSBB")%></td>               
                    <td width='11%' align='center'><span title='<%=exp.get("GUBUN")%>'><%=Util.subData(String.valueOf(exp.get("GUBUN")), 6)%></span></td>
                    <td width='13%' align='center'><span title='<%=exp.get("GMJM")%>'><%=Util.subData(String.valueOf(exp.get("GMJM")), 8)%></span></td>
                    <td width='7%' align='right'><%=Util.parseDecimal(exp.get("SBGB_AMT"))%>&nbsp;</td>
                    <td width='7%' align='right'><%=Util.parseDecimal(exp.get("TOT_DIST"))%>&nbsp;</td>
                    <td width='8%' align='center'>
                    <%  chk_cnt= mc_db.getCarMaintCnt(String.valueOf(exp.get("CAR_MNG_ID")) , String.valueOf(exp.get("JS_DT")) , AddUtil.parseInt(String.valueOf(exp.get("SBGB_AMT")) )  );
                      if ( chk_cnt > 0 ) {%>
                     <a href="javascript:go_cus_reg_maint('<%= exp.get("CAR_MNG_ID") %>', '<%= exp.get("CLIENT_ID") %>', '<%= exp.get("CAR_NO") %>', '<%= exp.get("GUBUN") %>^<%= exp.get("JS_DT") %>^<%= exp.get("TOT_DIST") %>^<%= exp.get("SBGB_AMT") %>^' )"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>  
                     <% } else {%>                    
                     <a href="javascript:go_cus_reg_maint('<%= exp.get("CAR_MNG_ID") %>', '<%= exp.get("CLIENT_ID") %>', '<%= exp.get("CAR_NO") %>', '<%= exp.get("GUBUN") %>^<%= exp.get("JS_DT") %>^<%= exp.get("TOT_DIST") %>^<%= exp.get("SBGB_AMT") %>^' )"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <% } %>
                    </td>
                    <td width='15%' align='left'><span title='<%=exp.get("REMARKS")%>'><%=Util.subData(String.valueOf(exp.get("REMARKS")), 8)%></span></td>
                     <td width='6%' align='center'><%=exp.get("USER_NM")%>&nbsp;</td>
                </tr>
                <%	total_su = total_su + 1;
					    total_amt   = total_amt  + AddUtil.parseLong(String.valueOf(exp.get("SBGB_AMT")));
		  		}%>
                <tr>                   
                    <td class="title">&nbsp;</td>      
                    <td class="title">&nbsp;</td>                 
                    <td class="title">&nbsp;</td>   
                    <td class="title">&nbsp;</td>              
                    <td class="title" colspan="2" style="text-align:right"><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>
                    <td class="title">&nbsp;</td>	
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>		
                    <td class="title">&nbsp;</td>			
                </tr>
            </table>
        </td>
	<tr>
		<td colspan=""></td>
        <td></td>
    </tr>
<%}else{%>
    <tr>
		<td class='line' width='32%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='68%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
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

