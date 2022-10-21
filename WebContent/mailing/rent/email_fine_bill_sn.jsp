<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, cust.member.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>


<%//�Ƹ���ī ���·�û����
	String m_id 	= request.getParameter("m_id")==null?"003458":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"S107HVEL00001":request.getParameter("l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");

	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String dem_dt 	= request.getParameter("dem_dt")==null?"":request.getParameter("dem_dt");
	String e_dem_dt 	= request.getParameter("e_dem_dt")==null?"":request.getParameter("e_dem_dt");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site 	= request.getParameter("r_site")==null?"":request.getParameter("r_site");
	int seq_no 	= request.getParameter("seq_no")==null?0:AddUtil.parseInt(request.getParameter("seq_no"));
		
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
	


	dem_dt = AddUtil.getReplace_dt(dem_dt);
	e_dem_dt = AddUtil.getReplace_dt(e_dem_dt);
	
	if(dem_dt.equals("")){
		dem_dt = e_dem_dt;
	}
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//��������� ��ȸ
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//�뿩�⺻����
	ContFeeBean fee = a_db.getContFee(m_id, l_cd, rent_st);
	
	//���������
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("MNG_ID")));
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("������������ⳳ"));
	
	
	//���·� ����
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
		
	if(gubun1.equals("")) 	gubun1 = "1";
	if(gubun2.equals("")) 	gubun2 = "4";
	if(s_kd.equals("")) 	s_kd = "1";
	

//System.out.println("email_fine_bill m_id=" +m_id + "|l_cd=" + l_cd + "|dem_dt=" + dem_dt+"|e_dem_dt="+e_dem_dt);
 
	Vector fines = afm_db.getFinePreDemList_sn( m_id, l_cd, dem_dt, e_dem_dt, sort, asc);

	int fine_size = fines.size();

	String firm_nm = "";
	String r_client_id = "";
	String coll_dt ="";
	long tot_fine = 0;
	for(int i = 0 ; i < fine_size ; i++){
			Hashtable ht = (Hashtable)fines.elementAt(i);
									
			if ( String.valueOf(ht.get("FIRM_NM")).equals("(��)�Ƹ���ī") && !String.valueOf(ht.get("CUST_NM")).equals("") ){
				firm_nm = String.valueOf(ht.get("CUST_NM"));
			} else {
				firm_nm = String.valueOf(ht.get("FIRM_NM"));
			}
			                    
			tot_fine += AddUtil.parseLong(String.valueOf(ht.get("PAID_AMT")));									 
			dem_dt = String.valueOf(ht.get("DEM_DT"));	
			//dem_dt = String.valueOf(ht.get("COLL_DT"));	
			coll_dt = String.valueOf(ht.get("COLL_DT"));		
		//	System.out.println("dem_dt="+ dem_dt);
			r_client_id = String.valueOf(ht.get("CLIENT_ID"));			
	}	
	
	if(firm_nm.equals("")){
		firm_nm 	= String.valueOf(base.get("FIRM_NM"));
		r_client_id = String.valueOf(base.get("CLIENT_ID"));
	}
	
//	System.out.println("ebill_fine_bill dem_dt 2="+ dem_dt);
	
	String member_id = "";
	String member_pw = "";
	
	// �� fms id, pwd
	if (!r_client_id.equals("")) {
		MemberBean  member = m_db.getMemberCase(r_client_id, "", "");
		member_id = member.getMember_id();
		member_pw = member.getPwd();
		
	}	
//	System.out.println(member_id + "|" + member_pw);
		
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>�Ƹ���ī �������·� û����</title>
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
            		<!-- �� FMS�α��� ��ư 
                    <td width=114 valign=baseline> <a href='http://fms.amazoncar.co.kr/service/index.jsp' target=_blank><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a></td>
					-->
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_top_e1.gif height=60 style='font-size:14px'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <span class=style1><b><%if (coll_dt.length()>7){%><%=coll_dt.substring(0,4)%>��&nbsp;<%=coll_dt.substring(5,7)%>��<%}else{%><%=coll_dt%><%}%></b></span></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35><span class=style2><span class=style1><b><%=firm_nm%> </b>��</span></span></td>
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
                                <td height=24>
								  <span class=style2><span class=style1><b>
								    <%if (dem_dt.length()>7){%>
								    <%=dem_dt.substring(0,4)%>��&nbsp;<%=dem_dt.substring(4,6)%>��&nbsp;<%=dem_dt.substring(6,8)%>��
									<%}else{%>
									<%=dem_dt%>
									<%}%>
								  </b></span> �����Ͻ� �ݾ��� <span class=style3><b><%=AddUtil.parseDecimal(tot_fine)%></b></span> ���Դϴ�.</span></td>
								
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>��FMS �α��� �� ���·� �޴��� �����Ͻø� ������������ Ȯ��/����Ͻ� �� �ֽ��ϴ�.  </span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>������ �ʿ��� �� �Ʒ� ������ �߱ޱ���� �����Ͻð� �ش� ����ó�� ��û�Ͻø� �������� �߱޹����� �� �ֽ��ϴ�.</span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>û������ �߼��� ���� ������� ���¿��� ����(CMS) �Ǵ� �����Ա��� ��ݿ��� �켱ó���˴ϴ�.</span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>(��, �ǻ���ڰ� ������ �����ϴ� ����� ���� ��(��翡 ������û)�� ����)</span></td>
                            </tr>
                         
                            <tr>
                                <td height=18><span class=style2>�Ƹ���ī�� �̿��� �ּż� �������� ����帮��, �ñ��Ͻ� ������ �����ø� ����ڿ��� ��ȭ�ֽñ� �ٶ��ϴ�.</span></td>
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
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>������ȣ</span></td>
                                <td bgcolor=ffffff width=231>&nbsp;<span class=style2><%=ht.get("CAR_NO")%>&nbsp;<%=ht.get("RES_ST")%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>����</span></td>
                                <td bgcolor=ffffff width=232>&nbsp;<span class=style2><%=ht.get("CAR_NM")%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>�����Ͻ�</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=ht.get("VIO_DT")%> </span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>���ݳ���</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=ht.get("VIO_CONT")%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>�������</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=Util.subData(String.valueOf(ht.get("VIO_PLA")), 15)%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>û�����</span></td>
                                <td bgcolor=ffffff>
                                    <table width=100% border=0 cellspacing=0 cellpadding=5>
                                        <tr>
                                            <td><span class=style2><%=ht.get("GOV_NM")%></span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>��������</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=ht.get("PROXY_DT")%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>���ݱݾ�</span></span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style3><%=AddUtil.parseDecimal(String.valueOf(ht.get("PAID_AMT")))%> ��</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr></tr><tr></tr><tr></tr>
<%	}%>             
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_6.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_img2.gif></td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_7.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_img4.gif></td>
                </tr>
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
                    <area shape="rect" coords="565,148,643,168" href="http://fms1.amazoncar.co.kr/mailing/fms/fms_info.html" target=_blank>
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style12>�� ������ �߽����� �����̹Ƿ� �ñ��� ������ <a href=mailto:tax@amazoncar.co.kr><span class=style14>���Ÿ���(tax@amazoncar.co.kr)</span></a>�� �����ֽñ� �ٶ��ϴ�.</span></td>
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
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=523><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
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