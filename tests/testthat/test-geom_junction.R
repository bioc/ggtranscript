# manually create the expected introns
test_introns <-
    dplyr::tibble(
        strand = c("+", "-"),
        tx = c("A", "B"),
        intron_start = c(201, 601),
        intron_end = c(299, 649)
    )

# create base plot to be used in downstream tests
test_introns_plot <- test_introns %>%
    ggplot2::ggplot(aes(
        xstart = intron_start,
        xend = intron_end,
        y = tx
    ))

##### geom_junction #####

testthat::test_that(
    "geom_junction() works correctly",
    {
        base_geom_junction <- test_introns_plot +
            geom_junction()
        w_param_geom_junction <- test_introns_plot +
            geom_junction(colour = "red", size = 2)
        w_aes_geom_junction <- test_introns_plot +
            geom_junction(aes(colour = tx))
        w_facet_geom_junction <- test_introns_plot +
            geom_junction() +
            ggplot2::facet_wrap(~tx)

        vdiffr::expect_doppelganger(
            "Base geom_junction plot",
            geom_junction
        )
        vdiffr::expect_doppelganger(
            "With param geom_junction plot",
            w_param_geom_junction
        )
        vdiffr::expect_doppelganger(
            "With aes geom_junction plot",
            w_aes_geom_junction
        )
        vdiffr::expect_doppelganger(
            "With facet geom_junction plot",
            w_facet_geom_junction
        )
    }
)