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
		
	if(!gubun4.equals("3")){
		s_dt = "";
		e_dt = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//???뺯??
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstimateBean [] e_r = e_db.getEstimateFmsList2(gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, s_dt, e_dt, s_kd, t_wd);
	int size = e_r.length;
	
	String admin_yn="";
	if(nm_db.getWorkAuthUser("??????",user_id)){
		admin_yn="Y";
	}
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//???뺸??
	function EstiDisp(est_id, set_code){	
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.set_code.value = set_code;		
		fm.target = 'd_content';
		if(set_code == '') 	fm.action = 'esti_mng_u.jsp';
		else  			fm.action = 'esti_mng_atype_u.jsp';
		fm.submit();
	}
	
	function EstiMemo(est_id, user_id){
		var SUBWIN="./esti_memo_i.jsp?est_id="+est_id+"&user_id="+user_id;	
		window.open(SUBWIN, "EstiMemoDisp", "left=50, top=50, width=620, height=650, scrollbars=yes");
	}
//-->
</script>
<script language='javascript'>
<!--
	/* Title ???? */
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
	
	//??ü????
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){
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
<body onLoad="javascript:init()">
<form action="esti_mng_u.jsp" name="form1" method="POST">
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
  <input type="hidden" name="from_page" value="/acar/estimate_mng/esti_mng2_sc_in.jsp">            
<table border=0 cellspacing=0 cellpadding=0 width=1730>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'> 
        <td width=470 class='line' id='td_title' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=40 class=title>????</td>
		    <td width=40 class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>					
                    <td width=110 class=title>?뿩??ǰ</td>
                    <td width=60 class=title>?뿩?Ⱓ</td>
                    <td width=120 class=title>????????</td>
                    <td width=100 class=title>??????</td>
                </tr>
            </table>
        </td>
        <td class='line' width=1260>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=100 class=title>????ó</td>			
                    <td width=200 class=title>????</td>
                    <td width=95 class=title>????????</td>
                    <td width=80 class=title>???뿩??</td>			
                    <td width=50 class=title>??????</td>			
                    <td width=80 class=title>??????</td>
                    <td width=60 class=title>????????</td>			
                    <td width=75 class=title>??????</td>									
                    <td width=70 class=title>???ô뿩??</td>												
                    <td width=60 class=title>?ۼ???</td>
                    <td width=100 class=title>??????DC</td>                    
                    <td width=250 class=title>?????ּ?</td>                    
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td width=470 class='line' id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <%for(int i=0; i<size; i++){
					bean = e_r[i];
					%>
                <tr> 
                    <td width=40 align=center><%=i+1%></td>
		    <td width=40 align=center><input type="checkbox" name="ch_l_cd" value="<%=bean.getEst_id()%>"></td>
                    <td width=110 align=center><%=c_db.getNameByIdCode("0009", "", bean.getA_a())%></td>
                    <td width=60 align=center><%=bean.getA_b()%>????</td>
                    <td width=120 align=center><a href="javascript:EstiDisp('<%=bean.getEst_id()%>','<%=bean.getSet_code()%>')"><%= AddUtil.ChangeDate3(bean.getReg_dt()) %></a></td>
                    <td width=100 align=center><span title='<%=bean.getEst_nm()%> || <%=bean.getMgr_nm()%>'><%=AddUtil.substringbdot(bean.getEst_nm(), 12)%></span></td>
                </tr>
                  <%}%>
                  <% if(size == 0) { %>
                <tr> 
                    <td width=700 align=center colspan="9">???ϵ? ????Ÿ?? ?????ϴ?.</td>
                </tr>
          <%}%>
            </table>
        </td>
        <td width=1260 class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%for(int i=0; i<size; i++){
    					bean = e_r[i];
    					
    					if(bean.getCtr_s_amt()>0){
    						bean.setFee_s_amt(bean.getCtr_s_amt());
    						bean.setFee_v_amt(bean.getCtr_v_amt());
    					}
    					%>
                <tr> 
                    <td width=100 align="center"><span title='<%=bean.getEst_tel()%>'><%=AddUtil.substringbdot(bean.getEst_tel(), 13)%></span></td>
                    <td width=200 align=center><span title='<%=bean.getCar_nm()+" "+ bean.getCar_name()%>'><%=AddUtil.substringbdot(bean.getCar_nm()+" "+ bean.getCar_name(), 28)%></span></td>
                    <td width=95 align="right"><%=Util.parseDecimal(bean.getO_1())%>??</td>
                    <td width=80 align="right">
                        <%if(bean.getUse_yn().equals("N")){%>
                        ????
                        <%}else{%>
                        <%    if(bean.getFee_s_amt() == 0 && bean.getEst_check().equals("????????")){%>
                            ????????
                        <%    }else{%>
                            <%    if(bean.getFee_s_amt() == -1){%>?̿<%}else{%><%=Util.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt())%>??<%}%>
                        <%    }%>
                        <%}%>
                        
                    </td>
                    <td width=50 align="center"><%=bean.getO_11()%>%</td>
                    <td width=80 align="right"><%=Util.parseDecimal(bean.getGtr_amt())%>??</td>
                    <td width=60 align="center"><%=bean.getRg_8()%>%</td>
                    <td width=75 align="right"><%=Util.parseDecimal(bean.getPp_s_amt()+bean.getPp_v_amt())%>??</td>
                    <td width=70 align="right"><%=Util.parseDecimal(bean.getIfee_s_amt()+bean.getIfee_v_amt())%>??</td>												
                    <td width=60 align=center><a href="javascript:EstiMemo('<%=bean.getEst_id()%>','<%=user_id%>')"><%=bean.getReg_nm()%></a></td>
                    <td width=100 align="right"><%=Util.parseDecimal(bean.getDc_amt())%>??</td>
                    <td width=250 align="center">
                        <%if (admin_yn.equals("Y")) {%>
                        [<%=bean.getPrint_type()%>/<%=Util.parseDecimal(bean.getCtr_s_amt()+bean.getCtr_v_amt())%>??]
                        <%}%>
                        <%=bean.getEst_email()%>
                    </td>
                </tr>
                <%}%>
                <% if(size == 0) { %>
                <tr> 
                    <td align=center height=25 colspan="11">???ϵ? ????Ÿ?? ?????ϴ?.</td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
