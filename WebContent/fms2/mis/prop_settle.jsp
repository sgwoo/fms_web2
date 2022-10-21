<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

    String s_user =  request.getParameter("s_month")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
   
   	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID			
	if(user_id.equals(""))	user_id = ck_acar_id;
	
    String dt		= "4";

	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
		
//제안캠페인변수 : cost_campaign 테이블
	Hashtable ht3 = ac_db.getCostCampaignVar("5");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");

	int amt1 			= AddUtil.parseInt((String)ht3.get("AMT1"));  //제안점수
	int amt1_per 		= AddUtil.parseInt((String)ht3.get("AMT1_PER")); //제안  적용비율 (인사고과용)
	int amt2 			= AddUtil.parseInt((String)ht3.get("AMT2"));  // 제안포상평가금액	
	int amt3 			= AddUtil.parseInt((String)ht3.get("AMT3"));  //댓글점수
		
	int cam_per 		= AddUtil.parseInt((String)ht3.get("CAM_PER"));  //캠페인포상금 적용비율
					
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_bus_prop");
		
	Vector vts2 = ac_db.getPropCampaign(save_dt, "5", "", "", "");
	int vt_size2 = vts2.size(); 
	long ave_amt = 0;
			
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--


//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}	

//변수수정
function updateVar(t_chk){
	var fm = document.form1;
	if(!confirm("변수값을 수정하시겠습니까?"))	return;	
	fm.action = "/fms2/mis/prop_var_iu.jsp?t_chk="+t_chk;
	fm.target = 'i_no';
	fm.submit();
}

//계산식보기
function view_sik(){
	window.open("man_cost_jung.jsp?popup=Y","sik","left=100,top=50,width=950,height=500,scrollbars=yes");
}

//프린트하기
function cmp_print(){
	window.open("prop_settle_print.jsp?save_dt=<%=save_dt%>&auth_rw=<%=auth_rw%>","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
}

//-->
</script>
</head>

<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 
<input type="hidden" name="gubun" value="5"> 
<input type="hidden" name="from_page" value="/fms2/mis/prop_settle.jsp"> 
<input type="hidden" name="save_dt" value="<%=save_dt%>"> 
<input type="hidden" name="year" value="<%=year%>"> 
<input type="hidden" name="tm" value="<%=tm%>"> 
<input type="hidden" name="o_cs_dt" 	value="<%=cs_dt%>">
<input type="hidden" name="o_ce_dt" 	value="<%=ce_dt%>">
<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > <span class=style5>제안캠페인(내근)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_campaign.gif align=absmiddle>&nbsp;
        <input type="text" name="ccs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
        ~ 
        <input type="text" name="cce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
    </tr>
</table>
<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><div align="right"><img src=/acar/images/center/arrow_gjij.gif align=absmiddle> : <%=AddUtil.ChangeDate2(save_dt)%></div></td>
    </tr>
</table>
 
<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
 	  <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='900'>
         <tr> 
           <td width='40' class='title' rowspan=2>순위</td>
           <td width='90' class='title' rowspan=2>부서</td>
           <td width='70' class='title' rowspan=2>성명</td>
           <td class='title' colspan=6 >제안내역</td>
           <td width='100' class='title' rowspan=2>점수 </td>	
           <td width='90' class='title' rowspan=2>포상<br>금액</td>	
           <td width="200" rowspan="2">
        	     <table width="100%" border="0" cellspacing="0" cellpadding="0">
        	     <tr style='text-align:right'>
        		  <td class="title_p" width="200" style='height:44; text-align=center;'>그래프</td>
        	    </tr>
          </table>
        	</td>
          </tr>
          <tr> 
           <td  width="55" class='title' >제안<br>건수</td>
           <td  width="55" class='title' >채택<br>건수</td>
           <td  width="60" class='title' >제안<br>점수</td>
           <td  width="70" class='title' >제안포상<br>평가금액</td>
           <td  width="60" class='title' >댓글<br>건수</td>
           <td  width="60" class='title' >댓글<br>점수</td>
          </tr>
       
	  
<%	if(vt_size2 > 0){
	   
     	long t_cnt1[] = new long[1]; //제안건수	
    	long t_cnt2[] = new long[1]; //채택선수
   	long t_cnt3[] = new long[1]; //의견건수
   		
      	long t_amt1[] = new long[1]; //채택금액
      	long t_amt2[] = new long[1]; //포상금액
      	long t_amt3[] = new long[1]; //제안점수
      	long t_amt4[] = new long[1]; //댓글점수
    
	long t_ave_amt = 0;
	    
    	long cam_amt = 0;	
    	long cam_amt1 = 0;	
   	long sum_cam_amt = 0;	
   
     	for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
							
				for(int j=0; j<1; j++){
							
					t_cnt1[j] += AddUtil.parseLong(String.valueOf(ht.get("CNT1")));	 //제안건수	
					t_cnt2[j] += AddUtil.parseLong(String.valueOf(ht.get("CNT2")));	 //채택선수
					t_cnt3[j]  += AddUtil.parseLong(String.valueOf(ht.get("CNT3"))); //의견건수
					t_amt1[j]  += AddUtil.parseLong(String.valueOf(ht.get("P_AMT"))) ; //채택금액
					t_amt2[j]  += AddUtil.parseLong(String.valueOf(ht.get("R_AMT"))) ; //평가점수
					t_amt3[j]  += AddUtil.parseLong(String.valueOf(ht.get("E_AMT"))) ; //제안점수
					t_amt4[j]  += AddUtil.parseLong(String.valueOf(ht.get("C_AMT"))) ; //댓글점수
					cam_amt	   += AddUtil.parseLong(String.valueOf(ht.get("PP_AMT"))) ; //캠페인금액						  
				}	
		}   		  				   
   		   
   		ave_amt = t_amt2[0]/vt_size2;
   		ave_amt =   AddUtil.ml_th_rnd((int)ave_amt);
   		
        for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
									
				cam_amt1 = AddUtil.parseLong(String.valueOf(ht.get("R_AMT")));   	
		 		  		           		
		   		float graph = 300;
		   		float  g1 = (float) cam_amt1 / 10000;
		 
 %>   		
	      <tr> 
	         <input type='hidden' name='bus_id' value='<%= ht.get("USER_ID") %>'>
	         <input type='hidden' name='p_amt' value='<%=cam_amt%>'>
	      	 <td align="center" ><%= i+1%></td>
	         <td align="center" ><%=ht.get("DEPT_NM")%>&nbsp;</td>
	         <td align="center" ><%=ht.get("USER_NM")%>&nbsp;
	         <% if (user_id.equals((String)ht.get("USER_ID")) || user_id.equals("000063") ) {%> 
	          <a href="javascript:MM_openBrWindow('prop_settle_detail_list.jsp?mng_id=<%= ht.get("USER_ID") %>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&mng_nm=<%=ht.get("USER_NM")%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>','popwin_list','scrollbars=yes,status=no,resizable=yes,width=800,height=500,top=30,left=30')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
             <% } %>        
	         </td>
	         <td align="right" ><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("CNT1"))))%></td>
	         <td align="right" ><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("CNT2"))))%></td>
	      
	         <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("E_AMT"))))%></td>    		
	         <td align="right" ><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("P_AMT"))))%></td>
	            <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("CNT3"))))%></td>    		
	         <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("C_AMT"))))%></td>    		
	         <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("R_AMT"))))%></td>
	         <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("PP_AMT"))))%></td>
	         </td>    
	         <td align="">
	          <table width="200" border="0" cellspacing="0" cellpadding="0">
         
		         <tr>
		           	<td width=200><img src=../../images/result1.gif width=<%=g1%> height=10></td>	
		       	 </tr>

	       	 </table>        
	      </tr>
	       <% 	} %> 
	      <tr> 
	        <td class=title style='text-align:center;' colspan=3>합계</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_cnt1[0])%></td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_cnt2[0])%></td>	   
	      
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt3[0])%></td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt1[0])%></td>
	          <td class=title style='text-align:right;'><%= Util.parseDecimal(t_cnt3[0])%></td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt4[0])%></td>
	        <td class=title style='text-align:right;'>*평균:<%= Util.parseDecimal(ave_amt)%></td>
	         <td class=title style='text-align:right;'><%= Util.parseDecimal(cam_amt)%></td>
	        <td class=title style='text-align:right;'>&nbsp;</td>
	      </tr>		
         
<%	}else{%>   
                  
  <tr>
	  <td> 
	   <table width="900" border="0" cellspacing="0" cellpadding="0">
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>

   </table>
    </td>
  </tr>
</table>
<br>
<!-- 평가기준 -->
  <table width="900" border="0" cellspacing="0" cellpadding="0">
  	<tr> 
      <td colspan=2><font color="#999999"><font color="#FF00FF">♣ 포상일</font>       : 제안심사가 완료된 시점에  포상일이 결정됩니다.  
        &nbsp;&nbsp;</td>
   	</tr> 
 
    <tr> 
      <td width="110">&nbsp;&nbsp;&nbsp;1. 평가기준기간</td>
      <td>: 
        <input type="text" name="cs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
		~
		<input type="text" name="ce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
	 </td>
	</tr>
    <% if ( auth_rw.equals("6") || auth_rw.equals("4") ) { %> 
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;2. 점수계산</td>
      <td>: 
       	제안점수*<input type="text" name="amt1" size="10" value="<%= AddUtil.parseDecimal(amt1) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		원&nbsp;+&nbsp;댓글점수*<input type="text" name="amt3" size="10" value="<%= AddUtil.parseDecimal(amt3) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원
	  </td>	
    </tr>
 
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;3. 적용효율</td>
      <td>:
               점수 *<input type="text" name="amt1_per" size="3" value="<%= AddUtil.parseDecimal(amt1_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
       %,&nbsp;포상금액  *<input type="text" name="cam_per" size="3" value="<%= AddUtil.parseDecimal(cam_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
       % 반영.       
      </td>
    </tr>
   <% } %>
   </table>  

<% if ( auth_rw.equals("6") || auth_rw.equals("4") ) { %> 
   <table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td align=right><a href='javascript:updateVar(1)' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify_bs.gif"  align="absmiddle" border="0"></a>
      <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
	      &nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:cmp_print()' title='프린트하기'><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a>
	  <%}%>
	  
      </td>
    </tr>
  </table>
<% } %>  

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>

</script>		
</body>
</html>

