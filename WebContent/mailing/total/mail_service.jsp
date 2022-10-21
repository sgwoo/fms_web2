<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd").toUpperCase();
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	if(l_cd.equals("") || l_cd.equals("null")){
		out.println("정상적인 호출이 아닙니다.");	
		return;
	}
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//cont
	ContBaseBean cont = a_db.getCont(m_id, l_cd);
		
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여갯수 카운터
	int fee_count = af_db.getFeeCount(l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//출고전대차 조회
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//대여기본정보
	ContFeeBean fee = a_db.getContFee(m_id, l_cd, rent_st);
	
	int tae_sum = af_db.getTaeCnt(m_id);
	
	Vector fee_scd = new Vector();
	int fee_scd_size = 0;
	//건별 대여료 스케줄 리스트
	if(rent_st.equals("")){
		fee_scd = af_db.getFeeScdMail(l_cd);
		fee_scd_size = fee_scd.size();
	}else{
		fee_scd = af_db.getFeeScdEmailRentst(l_cd, rent_st, "");//fee.getPrv_mon_yn()
		fee_scd_size = fee_scd.size();
		if(!rent_st.equals("1")) tae_sum=0;
	}
	
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean b_user2 = b_user;
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
	
	if(String.valueOf(base.get("BUS_ST_NM")).equals("에이전트")){
		b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID")));
		
		//에이전트 계약진행담당자
		if(!cont.getAgent_emp_id().equals("")){ 
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(cont.getAgent_emp_id()); 
				b_user.setUser_m_tel(a_coe_bean.getEmp_m_tel());
				b_user.setUser_nm		(a_coe_bean.getEmp_nm());
		}
	}
	
	//계좌번호 *로 가리기
	int acc_len = cms.getCms_acc_no().length();
	String acc_no = "";
	String acc_no1 = "";
	String acc_no2 = "";
	if(acc_len > 0){
		if(cms.getCms_acc_no().lastIndexOf("-") == -1){
			acc_no1 = "*******";
			if(acc_len > 7){
				acc_no2 = cms.getCms_acc_no().substring(7,acc_len);
			}
			acc_no = acc_no1+acc_no2;
		}else{
			acc_no1 = cms.getCms_acc_no().substring(0,cms.getCms_acc_no().lastIndexOf("-"));
			acc_no2 = cms.getCms_acc_no().substring(cms.getCms_acc_no().lastIndexOf("-"));
    		for (int i = 0; i < acc_no1.length(); i++){
	    		char c = (char) acc_no1.charAt(i);
    			if ( c == '-') 
    				acc_no += "-";
    			else 
	    			acc_no += "*";
    		}
			acc_no += acc_no+acc_no2;
		}
	}
	
	//차량 뒷번호 가리기
	int car_no_len = String.valueOf(base.get("CAR_NO")).length();
	String car_no = "";
	if(car_no_len > 3){
		car_no = String.valueOf(base.get("CAR_NO")).substring(0,car_no_len-2)+"**";
	}
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>자동차 관리 서비스 안내문</title>
<link href=http://fms1.amazoncar.co.kr/acar/main_car_hp/style.css rel=stylesheet type=text/css>
<style type="text/css">
<!--
.style1 {color: #88b228;font-size:12px;}
.style2 {color: #333333;font-size:12px;}
.style3 {color: #ffffff; }
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:11px;}
.style14 {color: #af2f98; font-size:8pt;}
-->
</style>


</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellspacing=0 cellpadding=0 style="background:url(https://fms5.amazoncar.co.kr/mailing/images/img_top.gif) no-repeat;">
                <tr>
                    <td width=474 valign=top>
                        <table width=474 border=0 cellspacing=0 cellpadding=0 >
                            <tr>
                                <td align=center>
                                    <table width=400 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=25></td>
                                        </tr>
                                        <tr>
                                            <td height=50 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/total/images/total_title.gif></td>
                                        </tr>
                                   <!-- 업체명 -->
                                        <tr>
                                            <td height=30 align=left style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span style="color:#88b228;"><b><%=base.get("FIRM_NM")%></b></span>&nbsp;님 귀하</td>
                                        </tr>
                                   <!-- 업체명 -->
                                        <tr>
                                            <td height=11></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_line_up.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor=f7f7f7>
                                                <table width=400 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan=3 height=15></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=12>&nbsp;</td>
                                                        <td width=386 align=left>
                                                            <table width=386 border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=18 style="font-family:nanumgothic;font-size:12px;">고객께서 이용하실 서비스에 대한 전반적인 사항을 아래와 같이 알려드립니다.</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=12>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 height=15></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_line_dw.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    
                    <td width=187 valign=top>
            			<table width=187 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=187 height=233>
                                    <table width=187 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=60 align=left></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/total/images/sup_bsn.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=1></td>
                                        </tr>
                              <!-- 담당자 전화번호 -->
                             			<tr>
                                            <td align=left height=15 style="font-family:nanumgothic;color:#FFFFFF;font-size:12px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=b_user.getUser_nm()%> <%=b_user.getUser_m_tel()%></strong></span></td>
                                        </tr>
                                        
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/total/images/sup_mng.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=1></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=15 style="font-family:nanumgothic;color:#FFFFFF;font-size:12px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=b_user2.getUser_nm()%> <%=b_user2.getUser_m_tel()%></strong></span></td>
                                        </tr>
                                         <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/total/images/sup_acct.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=1></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=15 style="font-family:nanumgothic;color:#FFFFFF;font-size:12px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=h_user.getUser_nm()%> <%=h_user.getHot_tel()%></strong></span><!--[$user_h_tel$]--> </td>
                                        </tr>

                              <!-- 담당자 전화번호 -->
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
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
        	<table width=658 border=0 cellspacing=0 cellpadding=0>
        		<tr>
        			<td width=319><a href="http://fms1.amazoncar.co.kr/mailing/total/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>&rent_way=<%=base.get("RENT_WAY")%>" target='aaa'><img src=https://fms5.amazoncar.co.kr/mailing/total/images/ban_scd.gif border=0></a></td>
        			<td width=339><a href="http://fms1.amazoncar.co.kr/mailing/total/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>&rent_way=<%=base.get("RENT_WAY")%>" target='aaa'><img src=https://fms5.amazoncar.co.kr/mailing/total/images/ban_cfms.gif border=0></a></td>
        		</tr>
        		<tr>
        			<td colspan=2><a href="http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>&rent_way=<%=base.get("RENT_WAY")%>" target='aaa'><img src=https://fms5.amazoncar.co.kr/mailing/total/images/ban_car.gif border=0></a></td>
        		</tr>
				<%if(base.get("RENT_WAY").equals("일반식")){%>
        <!--일반식일 경우-->
        		<tr>
        			<td colspan=2 height=20></td>
        		</tr>
        		<tr>
        			<td colspan=2><a href="http://fms1.amazoncar.co.kr/mailing/total/rep_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>&rent_way=<%=base.get("RENT_WAY")%>" target='aaa'><img src=https://fms5.amazoncar.co.kr/mailing/total/images/ban_rep.gif border=0></a></td>
        		</tr>
				<%}%>
        <!--일반식일 경우-->
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif style="font-family:nanumgothic;font-size:11px;">본 메일은 발신전용 메일이므로 궁금한 사항은 <a href=mailto:webmaster@amazoncar.co.kr><span style="font-size:11px;color:#af2f98;">수신메일(webmaster@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</td>
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
	                <td width=82><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
	                <td width=35>&nbsp;</td>
	                <td width=1 bgcolor=dbdbdb></td>
	                <td width=40>&nbsp;</td>
	                <td width=529><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
	            </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:webmaster@amazoncar.co.kr>
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