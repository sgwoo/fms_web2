<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.car_register.*,acar.car_mst.*, acar.offls_pre.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_actn.Offls_actnBean"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="CarKeyBn" scope="page" class="acar.car_register.CarKeyBean"/>
<jsp:useBean id="CarMngDb" scope="page" class="acar.car_register.CarMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<jsp:useBean id="olyBean" class="acar.offls_pre.Offls_preBean" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String st = request.getParameter("st")==null?"3":request.getParameter("st");
	String gubun = request.getParameter("gubun")==null?"firm_nm":request.getParameter("gubun");	
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	
	String q_sort_nm = request.getParameter("q_sort_nm")==null?"firm_nm":request.getParameter("q_sort_nm");	
	String q_sort = request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"00000000":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"99999999":request.getParameter("ref_dt2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rpt_no = request.getParameter("rpt_no")==null?"":request.getParameter("rpt_no");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String cmd = "jh";
	String[] pre = request.getParameterValues("pr");
	int imm_amt = request.getParameter("imm_amt")==null?0:Util.parseInt(request.getParameter("imm_amt"));
	


%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>????????</title>
<style type=text/css>
<!--
.style1 {
	font-size: 13px;
	font-weight: bold;
}
.style2 {
	font-size: 11px;
	font-weight: bold;
}
.style4 {
	color: #C00000;
	font-size: 11px;
	font-weight: bold;
}

.style3 {
color:26329e;
font-weight: bold;
}

.style5 {
	color: #000000;
	font-size: 11px;
	
}	

-->
</style>
<link href=/include/style_opt.css rel=stylesheet type=text/css>
</head>

<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/ScriptX.cab" >
</object>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<%
		for(int i=0; i<pre.length; i++){
		pre[i] = pre[i].substring(0,6);
		car_mng_id = pre[i];
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
	detail = olaD.getActn_detail(car_mng_id);
	int a=1000;
	//????????
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	//???????????????? ????????
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	//??????????&????&????????
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(rent_mng_id, rent_l_cd);
	//???????? ????
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	String white = "white";	
	CarKeyBn = CarMngDb.getCarKey(car_mng_id);
	//????????
	Off_ls_pre_apprsl ap_bean = rs_db.getCarBinImg2(car_mng_id);
	//????????
	Hashtable res = rs_db.getCarInfo(car_mng_id);
	
	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	Offls_preBean olyb[] = olpD.getPre_lst(gubun, gubun_nm, brch_id);
	int totCsum = 0;
	int totFsum = 0;
	String actn_cnt = ""; //?????? ????????
	String actn_id = olpD.getActn_id(car_mng_id);
	if(cmd.equals("")){
		olyBean = olpD.getPre_detail(car_mng_id); //???????????????????? ?????? ??????
	}else{
		olyBean = olpD.getPre_detail2(car_mng_id); //???????????? ?????? ??????
	}
	String car_no = olyBean.getCar_no();
	
	seq = olaD.getAuctionPur_maxSeq(car_mng_id);
%>		
<!-- ?????????????? -->
<form action="" name="form1" method="POST" >
<table  width=100% border=0 height= border=0 cellpadding=0 cellspacing=0 align=center >
	<tr>
      <td colspan="5" align="center" height=40></td>
    </tr>
	<tr>
		<td align=center><font size='2'>(?? ???????? ?????????? ??49???? ???? ?????????? ???????? ?????? ?????? ?????? ???? ?????? ?? ????.)</font></td>
    </tr>
</table>
<table width=100% border=1 height=90% border=0 cellpadding=0 cellspacing=0 >
    <tr>
      <td colspan="5" align="center" height=60><font size='10'><b>????????????????????</b></font></td>
    </tr>
    <tr>
      <td colspan="1" rowspan="4" align="center" width="10%" style="font-family:dodtum; font-size:16px !important;">????????<br>??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??</td>
      <td align="center" width="15%"  height=40 style="font-family:dodtum; font-size:16px !important;">??????????????</td>
      <td colspan="3" rowspan="1" style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_no()%></td>
    </tr>
    <tr>
      <td align="center" width="15%" height=40 style="font-family:dodtum; font-size:16px !important;">??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??</td>
      <td width="30%" style="font-family:dodtum; font-size:16px !important;">&nbsp;
	  <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>	 
	  </td>
      <td align="center" width="15%" height=40 style="font-family:dodtum; font-size:16px !important;">??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??</td>
      <td width="30%" style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=mst.getCar_nm()%> <%//=mst.getCar_name()%> </td>
    </tr>
    <tr>
      <td align="center" height=30 height=40 style="font-family:dodtum; font-size:16px !important;">??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;??</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_num()%></td>
      <td align="center" height=30 height=40 style="font-family:dodtum; font-size:16px !important;">??????????</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_form()%></td>
    </tr>
    <tr>
      <td align="center" height=40 style="font-family:dodtum; font-size:16px !important;">??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_y_form()%></td>
      <td align="center" height=40 style="font-family:dodtum; font-size:16px !important;">??&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;??</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getDpm()%> cc</td>
    </tr>
    <tr>
      <td colspan="5" style="font-family:dodtum; font-size:16px !important;">
	  <p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;????????<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;?? :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?????????????? :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?? :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?????????? :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?????? ?????? ???? ?????????? ???????? ???? ?????? ?????? ????????<p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;???????? ???????????????? ?????????????????? ?? ?????????? ?????? <p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?????? ???? ?????? ?????? ?? ?????? ?????????? ?? ???????? ??????<p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?????? ???????? ???? ?????? ???? ?? ???? ????????, ?????? ?????? <p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?????? ????????(????????????)???? ???????? ???? ??????.<p><p><br>
	  
	  <center><%=AddUtil.getDate().substring(0,4)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.<p><p><br>
	  ??????(??????)&nbsp;&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?? :&nbsp;???????? ????????&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(??)</center><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?? :&nbsp;??????????  ???????? ?????????? 8, 802 (????????, ????????)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;???????????? :&nbsp;115611-0019610&nbsp;&nbsp;<p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;??<p>
	  </td>
    </tr>
</table>
    
<table>
	<tr>
		<td style="font-family:dodtum; font-size:16px !important;">?????????? 1990.  8.  27<br>???? 33150 - 9277</td>
    </tr>
</table>
</form>
<!-- ???????????????? -->

<!-- ?????????? -->
<form name='form2' method='post' action=''>
<div>
<table width=754 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td bgcolor=#FFFFFF valign=top align=center>
            <table width=714 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=15></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=428 align=center rowspan=3><img src=/acar/images/content/name.gif></td>
                                <td align=right>
                                    <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>?? ?? ??</td>
                                            <td bgcolor=#FFFFFF align=center><%=AddUtil.getDate2(1)%> &nbsp;&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp; <%=AddUtil.getDate2(2)%>&nbsp;&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp; <%=AddUtil.getDate2(3)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=7></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>????????</td>
                                            <td bgcolor=#FFFFFF>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>????????</td>
                                            <td bgcolor=#FFFFFF>&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=12></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td bgcolor=#dddddd height=24 width=8% align=center><b>?? ??</b></td>
                                <td bgcolor=#FFFFFF colspan=2>&nbsp;<%=detail.getCar_jnm() + " " +detail.getCar_nm() %></td>
                                <td bgcolor=#dddddd width=6% align=center><b>?? ??</b></td>
                                <td bgcolor=#FFFFFF colspan=2><span class=style5>&nbsp;A/T &nbsp;M/T &nbsp;SAT &nbsp;CVT</span></td>
                                <td bgcolor=#dddddd width=7% align=center><b>??????</b></td>
                                <td bgcolor=#FFFFFF colspan=2 width=10% align=right><span class=style5><%=detail.getDpm()%>CC&nbsp;</span></td>
                                <td bgcolor=#dddddd width=8% align=center><b>??????</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5>DR&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>????????</b></td>
                                <td bgcolor=#FFFFFF width=24%>&nbsp;<b><%=detail.getCar_no()%></b></td>
                                <td bgcolor=#dddddd width=8% align=center><b>????????</b></td>
                                <td bgcolor=#FFFFFF colspan=6>&nbsp;<b><%=detail.getCar_num()%></b></td>
                                <td bgcolor=#dddddd align=center><b>????<br>????</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5> ????&nbsp;<br>TON&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>?? ??</b></td>
                                <td bgcolor=#FFFFFF>&nbsp;<b><%=detail.getCar_y_form()%></b></td>
                                <td bgcolor=#dddddd rowspan=2 align=center><b>?? ??</b></td>
                                <td bgcolor=#FFFFFF rowspan=2 colspan=5>
                                    <table width=100% border=0 cellspacing=0 cellpadding=3>
                                        <tr><td><span class=style5>A/C &nbsp;P/S &nbsp;ADL &nbsp;CDP &nbsp;ABS &nbsp;???????? &nbsp;?????? <br>
                                                ?????????? &nbsp;??????(??????????) &nbsp;ECS &nbsp;AV <br>
                                                ??????????(&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</span></td>
                                        </tr>
                                    </table>
                                <td bgcolor=#dddddd width=6% align=center><b>?? ??</b></td>
                                <td bgcolor=#FFFFFF colspan=2>
                                <span class=style5>&nbsp;&nbsp;
                                <%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%>                                
                                </span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>??????</b></td>
                                <td bgcolor=#FFFFFF>&nbsp;<b><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></b></td>
                                <td bgcolor=#dddddd align=center><b>?? ??</b></td>
                                <td bgcolor=#FFFFFF colspan=2><span class=style5>&nbsp;<%=detail.getColo()%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>????????</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5>Km ?? ????&nbsp;</span></td>
                                <td bgcolor=#dddddd align=center><b>????????</b></td>
                                <td bgcolor=#FFFFFF colspan=2 width=15%><span class=style5>&nbsp;200 &nbsp;&nbsp;?? &nbsp;&nbsp;&nbsp;&nbsp;?? &nbsp;&nbsp;&nbsp;&nbsp;??</span></td>
                                <td bgcolor=#dddddd width=8% align=center><b>????????</b></td>
                                <td bgcolor=#FFFFFF colspan=3><span class=style5>???? &nbsp;???? &nbsp;???? &nbsp;????</span></td>
                                <td bgcolor=#dddddd align=center><b>????????</b></td>
                                <td bgcolor=#FFFFFF><span class=style5>&nbsp;????&nbsp;????&nbsp;????</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td width=39% bgcolor=#FFFFFF align=center valign=top height=140>
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=2 height=22>&nbsp;<span class=style3>????????????</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>?????????? : (??????????)</td>
                                            <td>&nbsp;</td>
                                            <td>?????????? : (??????????)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>?????????? : (??????????)</td>
                                            <td>&nbsp;</td>
                                            <td>?????????? : (??????????)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>?????????? : (??????????)</td>
                                            <td>&nbsp;</td>
                                            <td>????????,???? : (?? ?? ??)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>?????????? : (??????????)</td>
                                            <td>&nbsp;</td>
                                            <td>?????????? : (??????????)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>?????????? : (??????????)</td>
                                            <td>&nbsp;</td>
                                            <td>?????????? : (??????????)</td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=12% bgcolor=#FFFFFF align=center valign=top height=140>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22 align=center><span class=style3>????????????</span></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=49% bgcolor=#FFFFFF rowspan=2 align=center valign=top height=340> 
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22 colspan=2>&nbsp;<span class=style3>????????????</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td rowspan=7><img src=/acar/images/content/cp_img.gif height=291></td>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td colspan=2 bgcolor=#dddddd align=center height=15>????????</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center width=55 height=15>????????</td>
                                                        <td bgcolor=#ffffff align=center>P</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>????????</td>
                                                        <td bgcolor=#ffffff align=center>X</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>?? ?? ??</td>
                                                        <td bgcolor=#ffffff align=center>U</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>????????</td>
                                                        <td bgcolor=#ffffff align=center>A</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>?? ?? ??</td>
                                                        <td bgcolor=#ffffff align=center>C</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>?? ?? ??</td>
                                                        <td bgcolor=#ffffff align=center>T</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>????????</td>
                                                        <td bgcolor=#ffffff align=center>L</td>
                                                    </tr>
                                                </table>
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 Cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>????????</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>?? ?? (??????)</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>?????? (??????)</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>????????</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>?? ?? (??????)</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>?? ?? (??????)</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>????????</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>?? ?? ??</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table> 
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=#FFFFFF rowspan=2 align=center valign=top height=290>
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22>&nbsp;<span class=style3>????????(????)</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td rowspan=2 bgcolor=#dddddd align=center>??????<br>??????</td>
                                                        <td colspan=2 bgcolor=#FFFFFF height=22 align=center>?????????? ????</td>
                                                        <td bgcolor=#FFFFFF align=center>??</td>
                                                        <td bgcolor=#FFFFFF align=center>????</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=2 bgcolor=#FFFFFF height=22 align=center>????????????</td>
                                                        <td bgcolor=#FFFFFF align=center>????</td>
                                                        <td bgcolor=#FFFFFF align=center>????</td>
                                                    </tr>
                                                    <tr>
                                                        <td rowspan=2 bgcolor=#dddddd align=center>??????<br>??????</td>
                                                        <td bgcolor=#FFFFFF height=22 align=center>????????</td>
                                                        <td bgcolor=#FFFFFF align=center>????????</td>
                                                        <td bgcolor=#FFFFFF align=center>????????</td>
                                                        <td bgcolor=#FFFFFF align=center>????????</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#FFFFFF height=38 align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;<span class=style3>???? ????????</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;?????????? :</td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;????&nbsp;??&nbsp;?? :&nbsp;&nbsp;<%=detail.getP_car_off_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;?????????? :&nbsp;&nbsp;<%=detail.getP_emp_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;????&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?? :
                                            <!--
											<%// if ( detail.getP_emp_id().equals("011815")) {%>D000137
                                            <%//} else {%>D000328
                                            <%//} %>
											-->
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;?????????? :</td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;?????????????? :&nbsp;&nbsp;<%=detail.getP_rpt_no()%></td>
                                        </tr>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                    </table>
                                </td>
                                <td bgcolor=#FFFFFF align=center height=190 valign=top>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td height=22 align=center><span class=style3>????????<br>(????????)</span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=#FFFFFF align=center height=90><span class=style3>??????</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td bgcolor=#FFFFFF align=center>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=48% align=center valign=top>
                                                <table width=96% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=22>&nbsp;<span class=style3>?????????? (917)</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=18% rowspan=2 align=center bgcolor=#dddddd>????????</td>
                                                                    <td bgcolor=#ffffff rowspan=2 align=center>115611 - 0019610</td>
                                                                    <td width=18% align=center bgcolor=#dddddd height=25>????</td>
                                                                    <td bgcolor=#ffffff align=center>(??)????????</td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd height=25>????????</td>
                                                                    <td bgcolor=#ffffff align=center>02-392-4243</td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd height=32>?? ??</td>
                                                                    <td bgcolor=#ffffff colspan=3>&nbsp;?????? ???????? ???????? 17-3 ???????? 802??</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd><font color=c00000><b>??????</b></font></td>
                                                                    <td bgcolor=#ffffff height=30 align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=9% align=center><b>,</b></td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=12% align=center>????</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd><font color=c00000><b>??????</b></font></td>
                                                                    <td bgcolor=#ffffff height=30 align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=9% align=center><b>,</b></td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=12% align=center>????</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd>?? ??<br>?? ??</td>
                                                                    <td bgcolor=#ffffff height=60 align=center>
                                                                        <table width=95% border=0 cellspacing=0 cellpadding=0>
                                                                            <tr>
                                                                                <td height=25>?????? ( ???????? )  &nbsp;&nbsp;???????? ( ???? )</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=25>???????? ( 140 - 004 - 023871 )</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#ffffff>??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??<br>????????</td>
                                                                    <td bgcolor=#ffffff>
                                                                        <table width=100% border=0 cellpadding=3 cellspacing=0>
                                                                            <tr>
                                                                                <td valign=top height=44 align=center><font style="font-size:5pt">?????????? ?????????? ???????? ?????????? ???????? ??????????.</font></td>
                                                                                <td align=right align=right><b>(??)</b></td>
                                                                             </tr>
                                                                         </table>
                                                                     </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#ffffff>?? ?? ??<br>????????</td>
                                                                    <td bgcolor=#ffffff>
                                                                        <table width=100% border=0 cellpadding=3 cellspacing=0>
                                                                            <tr>
                                                                                <td valign=top  height=44 align=center valign=top><font style="font-size:5pt">?????????? ?????????? ???????? ?????????? ???????? ??????????.</font></td>
                                                                                <td align=right><b>(??)</b></td>
                                                                             </tr>
                                                                         </table>
                                                                     </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=52%>
                                                <table width=99% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=6></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=22 style="font-size:11px">&nbsp;<font color=c00000><b>?? ???????? ?? ????????</b></font></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; ?? ?????? ???? ???????????? ?????? ????????????.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ??) ?????? 1.5 RS</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; ?? ?????????? ?????????? ????????????.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp;<b> ?? ?????????? ???? ?????? ???? ???????? ?????????? ??????????<br>&nbsp;&nbsp;&nbsp;&nbsp;  ?????? ????????????.</b></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; ?? ?????????????? ????????, ????????, ????????, ???????? ???? ??????<br>&nbsp;&nbsp;&nbsp;&nbsp;  ????????????.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; ?? ?? ?????? ?????????? ?????? ???????? ???? ???? ?????????? ??????<br>&nbsp;&nbsp;&nbsp;&nbsp; ???????? ???? ???? ?????????? ????????.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; ?? ???????????? ?????? ??????(????)?? ?????? ???? ??????????????<br>&nbsp;&nbsp;&nbsp;&nbsp; ?????? ???????? ?? ?????? ????????.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; ?? </b>?????? ???????? ???????????? ????????, ?????? ?????? ???? ?? ????<br>&nbsp;&nbsp;&nbsp;&nbsp; ???? ???????? ???? ???????? ?????????? ????????.</b></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=13></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=99% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd colspan=2 height=18><span class=style5>?? ???????? ( ?????? ?????? V???? ???????? )</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#FFFFFF height=18><span class=style5>????/??????????</span></td>
                                                                    <td align=center bgcolor=#FFFFFF><span class=style5>??????????</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td bgcolor=#ffffff align=center width=49% valign=top>
                                                                        <table width=95% border=0 cellpadding=0 cellspacing=0>
                                                                            <tr>
                                                                                <td height=5></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ???????????? ????</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ?????????? 1??</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ?????????????? ??????(????????)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ????????(??????) ??????????</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ???????? ??????????????(????<????)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ???????????? ???? 1??(??????????)</font></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td bgcolor=#ffffff align=center width=51%>
                                                                        <table width=95% border=0 cellpadding=0 cellspacing=0>
                                                                            <tr>
                                                                                <td height=5></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ???????????? ????</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ???? ??????????/?????????? ??1??</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ?????????????? ??????(????????)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ????????(??????) ??????????</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ???????? ??????????????(????????)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">?? ???????????????? (??, ????????????<br>&nbsp;&nbsp;&nbsp; ???????? ?????? ?????? ?????? ????)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=3></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=7></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=97% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=24 width=20%><img src=/acar/images/content/glovis.gif align=absmiddle></td>
                                <td><b>??????????????????????</td>
                                <td align=right><b>???????? :</b> 031-760-5300, 5354, 5350&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>FAX :</b> 031-760-5390</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
</table>

</form>
</div>
<!--?????????? ??-->
<!-- ?????????? -->

<form name='form3' method='post' action=''>

<div>
<table width=754 border=0 cellpadding=18 cellspacing=1 bgcolor=5B608C>
    <tr>
        <td bgcolor=#FFFFFF valign=top align=center>
            <table width=708 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=20% align=center><img src=/acar/images/content/logos.gif width=92 height=25></td>
                    <td align=right valign=bottom>???????? : <%=olyBean.getCar_doc_no()%> ??</td>
                </tr>
                <tr>
                    <td height=7 colspan=2 align=center></td></tr>
                <tr>
                    <td colspan=2><img src=/acar/images/content/bar2.gif width=708 height=37></td>
                </tr>
                <tr align=center>
                    <td colspan=2>
                        <table width=690 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=28>(??)???????????? ?????? ???????? ???? ???? ?????? ?????? ????????. </td>
                            </tr>
                            <tr>
                                <td height=12><span class=style1>1. ???????????? ???? ????????</span></td>
                            </tr>
                            <tr>
                                <td height=20>?????? ???? ???????? ?????? ?? ????????. </td>
                            </tr>
                            <tr>
                                <td height=20>
                                    <table width=690 border=0 cellpadding=0 cellspacing=1 bgcolor=cde83a>
                                        <tr>
                                            <td width=20% align=center bgcolor=e4f778><span class=style2><font color=4e6101>????????</font></span></td>
                                            <td height=48 bgcolor=#FFFFFF style="font-size:11px">&nbsp;&nbsp;&nbsp;???? ?? ???????? ???? ?????? ???? ?? ???????????? ?????? ?????? ?????? ????????<br>
                                                &nbsp;&nbsp;&nbsp;(??, ????, ?????????????? ?? ???? ?? ?????? ?????? ????)<br>
                                                &nbsp;&nbsp;&nbsp;* ?????? ???? ???? ???? ????, ?????? ???? ?? ???? ?????? ???? ???????? ????????.</td>
                                        </tr>
                                        <tr>
                                            <td align=center bgcolor=e4f778><span class=style2><font color=4e6101>????????</font></span></td>
                                            <td height=48 bgcolor=#FFFFFF style="font-size:11px">&nbsp;&nbsp;&nbsp;???????? : ???????????? 7??<br>
                                                &nbsp;&nbsp;&nbsp;???????? : ?? ???????? <%=AddUtil.parseDecimal(AddUtil.parseInt((String)olyBean.getKm())+1000)%>km ???? (???? ???????? = <%=AddUtil.parseDecimal((String)olyBean.getKm())%>km)<br>
                                                &nbsp;&nbsp;&nbsp;* ???? ???? ???? ???????? ?? ???? ?????? ???? ???????? ?????? ????</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=3></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style1>2. ????????</span></td>
                            </tr>
                            <tr>
                                <td height=20 style="font-size:11px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?? ?????????? ?????? ???????? ???????????? ???????? ??????. <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?? ????????<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ???????? ?????? ???????? ?? ???? ?????? ?????? ???? ?????? ??????.                            <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ?????? ???????? ?????? ???????????? ???????? ??????.                            <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ??????????(??????), ???????????? ?????? ???? ?????? ??????.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ?????????? ?????? ?????????? ???? ??????????.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ???? ?????? ?????? ?????? ?????? ???? ???????? ???? ????????.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?? ?????? ???? ?????? ?????????? ?????? ???? ????????(??????,?????? ??)?? ???????? ??????????.</td>
                            </tr>
                            <tr>
                                <td height=22><span class=style1>3. ???? ???? ????</span></td>
                            </tr>
                            <tr>
                                <td height=20>
                                    <table width=690 border=0 cellpadding=0 cellspacing=1 bgcolor=cde83a>
                                        <tr align=center>
                                            <td width=20% height=20 bgcolor=e4f778><span class=style2><font color=4e6101>?? ??</font></span></td>
                                            <td width=30% bgcolor=#FFFFFF><span class=style4><%=olyBean.getCar_jnm()%></span></td>
                                            <td width=20% bgcolor=e4f778><span class=style2><font color=4e6101>????????</font></span></td>
                                            <td bgcolor=#FFFFFF><span class=style4><%=olyBean.getCar_no()%></span></td>
                                        </tr>
                                        <tr align=center>
                                            <td height=20 bgcolor=e4f778><span class=style2><font color=4e6101>????????</font></span></td>
                                            <td bgcolor=#FFFFFF style="font-size:11px">&nbsp;\ <%=AddUtil.parseDecimal(olyBean.getCar_cs_amt() + olyBean.getCar_cv_amt() + olyBean.getSd_cs_amt() + olyBean.getSd_cv_amt())%></td>
                                            <td bgcolor=e4f778><span class=style2><font color=4e6101>????????</font></span></td>
                                            <td bgcolor=#FFFFFF style="font-size:11px"><%=olyBean.getCar_num()%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=2></td>
                            </tr>
                            <tr>
                                <td height=25><span class=style1>4. ???????? ???????? ???? : ????</span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style1>5. ???????? ???????? ???????? : ????</span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style6>?? ???????? ???????? ???? ?????????? ???????? ????????, ?? ?????????? ?????? ?????? ???? ??????????. </span></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=2><img src=/acar/images/content/bar1.gif width=708 height=37></td>
                </tr>
                <tr align=center>
                    <td colspan=2 height=340>
                        <table width=690 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=28>?????? ???? ???? ???????? ???????? ???????? ?? ????(Put Option)?? ?????? ??????????.</td>
                            </tr>
                            <tr>
                                <td  valign=top>
                                    <table width=690 border=0 cellspacing=0 cellpadding=0 background=/acar/images/content/put.JPG height=325>
                                        <tr>
                                            <td>
                                                <table width=690 border=0 cellpadding=0 cellspacing=0>
                                                    <tr>
                                                        <td height=17></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=198>&nbsp;</td>
                                                        <td width=421><font color=FFFFFF><b>???????????</b></font></td>
                                                        <td width=39>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td height=10 colspan=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td style="font-size:11px">
                                                        ?????????? ?????? ?????? ???????? ???? ????????, ???? ???? ???????? ??????????<br>
                                                        ?????????? ???????? ????????, ???? ???????? ?????? ???????? ?????????? 95%??<br>
                                                        ????????
???????? ??????????????. ???? ?????? ???? ?????? ???? ????????????,??<br>
                                                        ?? ?? ?????????? ?????? ??????????. ?????? ???????? ???? ???????? ???????? ??<br>
                                                        ???????? ?? ?????? ???????? ???? ???? ???????? ?????? ??????????, ?????? ????<br>???? ?????????? ???? ??????
?? ???? ????????????????????????.<br><font color=999999>(????????:2008?? 04?? 25??)</font></td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=11></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td width=56>&nbsp;</td>
                                                        <td width=288 valign=top>
                                                            <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td><span class=style3>????????</span> <span class=style5>: ???????????? 52?? ~56???? (??????????)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    (8???? ?? ~ ????????)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=7></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>?????????? ???? ???????? ????</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=5></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>1. ???????? : ???? ???????? ?????? ?????? ???????? ??<br>&nbsp;&nbsp;&nbsp;&nbsp;?????? ????(??????, ???? ?????? ??)?? ?????? ????<br>&nbsp;&nbsp;
                                                                    &nbsp;?? ?????? ???? (???????????? ????,?????????? ????)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=3></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>2. ???????? : ?????????? 95%(???????? ????)<br>&nbsp;&nbsp;&nbsp;&nbsp;(??, ???????? ?????? ??????????, ??????, ?????? ??<br>&nbsp;&nbsp;&nbsp;&nbsp;?????????? ????)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=3></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>3. ???????? : ??3?? ?????? ???? ??3?????? ???? ??????<br>&nbsp;&nbsp;&nbsp;&nbsp;?????????? ???????? ???? ?? ????</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=25>&nbsp;</td>
                                                        <td width=320>
                                                            <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td><span class=style3>????????</span><span class=style5> : ?????? ???????? ???????? (??,???????? ??<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;???????? ?????????? ???? ???? ???? ????,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?????? ????)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=9></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>???????? ???? ????</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=5></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>1. ???????? : &nbsp;&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)olyBean.getKm())+1000)%>km ????<br>&nbsp;&nbsp;&nbsp;&nbsp;(?????? ???????? ???? 1000km ??????)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=2></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>2. ???????????? ??????</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=2></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>3. ??3?????? ?????? ???? (???????? ????)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=11></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>???????? ?? ????????<br>(??????, ???????? ???? ????????)</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=25></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr align=center>
                    <td colspan=2>
                        <table width=670 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td height=20 align=right colspan=2><%=AddUtil.getDate3(Util.getDate())%>&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=right valign=middle width=83%><span class=style1>???????? ???????? ????????</span></td>
                                <td align=right><img src=/acar/images/content/sign.gif  align=absmiddle></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=15 colspan=2>&nbsp;&nbsp;<span class=style6>?? ?????????? ?????? ??????, ???? ?????? ???? ??????????.</span></td>
                </tr>
                <tr>
                    <td height=15 colspan=2>&nbsp;&nbsp;???? ???????? ???????? 17-3 ?????????????? 8?? ( http://www.amazoncar.co.kr)  &nbsp;&nbsp;TEL. 02) 392-4243 / FAX. 02) 757-0803</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<!-- ?????????? ?? -->
<div style="page-break-after: always"></div>
<%}%>
</body>
</html>

<script>
onprint();

function onprint(){
	
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}	

function IE_Print() {
	factory.printing.header = ""; //?????????? ????
	factory.printing.footer = ""; //?????????? ????
	factory.printing.portrait = true; //true-????????, false-????????    
	factory.printing.leftMargin = 5.0; //????????   
	factory.printing.topMargin = 5.0; //????????    
	factory.printing.rightMargin = 5.0; //????????
	factory.printing.bottomMargin = 5.0; //????????
	factory.printing.Print(true, window);//arg1-????????????????(true or false), arg2-??????????or??????????
}
</script>

