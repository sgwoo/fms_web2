<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, cust.member.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	int seq_no 	= request.getParameter("seq_no")==null?0:AddUtil.parseInt(request.getParameter("seq_no"));
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site 	= request.getParameter("r_site")==null?"":request.getParameter("r_site");
	
		
	String s_kd 	= request.getParameter("s_kd")==null?"":	request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":	request.getParameter("t_wd");
	String sort 	= request.getParameter("sort")==null?"":	request.getParameter("sort");
	String asc 		= request.getParameter("asc")==null?"":		request.getParameter("asc");
	String idx 		= request.getParameter("idx")==null?"":		request.getParameter("idx");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":	request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":	request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":	request.getParameter("gubun3");
			
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//?????????? ????
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//????????????
	ContFeeBean fee = a_db.getContFee(m_id, l_cd, rent_st);
	
	//??????????
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("MNG_ID")));
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("??????????????????"));
	
	
	//?????? ????
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
		
	if(gubun1.equals("")) 	gubun1 = "1";
	if(gubun2.equals("")) 	gubun2 = "4";
	if(s_kd.equals("")) 	s_kd = "1";
	

	
	//??????????
	Vector fines = afm_db.getFinePreDemList3( m_id, l_cd, c_id, seq_no, sort, asc);
	int fine_size = fines.size();
	
	String dem_dt ="";
	String firm_nm = "";
	String r_client_id = "";
	
	long tot_fine = 0;
	for(int i = 0 ; i < fine_size ; i++){
			Hashtable ht = (Hashtable)fines.elementAt(i);
						
			
			if ( String.valueOf(ht.get("FIRM_NM")).equals("(??)????????") && !String.valueOf(ht.get("CUST_NM")).equals("") ){
				firm_nm = String.valueOf(ht.get("CUST_NM"));
			} else {
				firm_nm = String.valueOf(ht.get("FIRM_NM"));
			}
			                    
			tot_fine += AddUtil.parseLong(String.valueOf(ht.get("PAID_AMT")));									 
			dem_dt = String.valueOf(ht.get("DEM_DT"));	
		//		System.out.println("dem_dt="+ dem_dt);
			r_client_id = String.valueOf(ht.get("CLIENT_ID"));			
	}	
	
	//System.out.println("dem_dt 2="+ dem_dt);
	
	// ???? fms id, pwd
	MemberBean  member = m_db.getMemberCase(r_client_id, "", "");
//	System.out.println(member.getMember_id() + "|" + member.getPwd());
		
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>???????? ?????? ????</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #63676a}
.style3 {color: #ff8004}
.style4 {color: #c09b33; font-weight: bold;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- ???? FMS?????? ???? -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href='http://fms.amazoncar.co.kr/service/index.jsp' target=_blank><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_top_e2.gif height=60 style='font-size:14px'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style1><b></b></span></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35><span class=style2><span class=style1><b><%=firm_nm%> </b>??</span></span></td>
                    <td width=221><span class=style2><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%=b_user.getUser_nm()%>&nbsp;&nbsp;<%=b_user.getUser_m_tel()%></span></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine2.gif>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=636>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <!--<td height=24><span class=style2><span class=style1><b></b></span> ???????? ?????? <span class=style3><b><%=AddUtil.parseDecimal(tot_fine)%></b></span> ????????.</span></td>-->
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>?????????? ?????????? ?????? ???????? ?????? ?????? ????????. </span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>????FMS ?????? ?? ?????? ?????? ?????????? ?????? ???????? ???????? ?? ????????.  </span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>?????????? ?????? ?????? ???????? ??????????, ???????? ?????? ???????? ?????? ?????????? ?????????? ????????.</span></td>
                            </tr>
							<tr>
                                <td height=18><span class=style2></span></td>
                            </tr>
                        </table>
                    </td>
                    <td width=20>&nbsp;</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine_dw.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_3.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
<%	for(int i = 0 ; i < fine_size ; i++){
			Hashtable ht = (Hashtable)fines.elementAt(i);%>               
                
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                        
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>????????</span></td>
                                <td bgcolor=ffffff width=231>&nbsp;<span class=style2><%=ht.get("CAR_NO")%>&nbsp;<%=ht.get("RES_ST")%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>????</span></td>
                                <td bgcolor=ffffff width=232>&nbsp;<span class=style2><%=ht.get("CAR_NM")%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>????????</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=ht.get("VIO_DT")%> </span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>????????</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=ht.get("VIO_CONT")%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>????????</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=Util.subData(String.valueOf(ht.get("VIO_PLA")), 15)%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>????????</span></td>
                                <td bgcolor=ffffff>
                                    <table width=100% border=0 cellspacing=0 cellpadding=3>
                                        <tr>
                                            <td><span class=style2><%=ht.get("GOV_NM")%></span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
							<!--
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>????????</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=ht.get("PROXY_DT")%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>????????</span></span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style3><%=AddUtil.parseDecimal(String.valueOf(ht.get("PAID_AMT")))%> ??</span></td>
                            </tr>
							-->
                        </table>
                    </td>
                </tr>
                <tr></tr><tr></tr><tr></tr>
<%	}%>             
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_5.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_img1.gif usemap=#map border=0></td>
                </tr>
                <map name="Map">
                    <area shape="rect" coords="567,162,643,182" href="http://fms1.amazoncar.co.kr/mailing/fms/fms_info.html" target=_blank>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style12>?? ?????? ???????? ?????????? ?????? ?????? <a href=mailto:tax@amazoncar.co.kr><span class=style14>????????(tax@amazoncar.co.kr)</span></a>?? ?????????? ????????.</span></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=112><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>